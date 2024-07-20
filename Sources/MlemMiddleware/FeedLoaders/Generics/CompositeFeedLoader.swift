//
//  CompositeFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-09.
//

import Foundation
import Semaphore

/// This is a special type of FeedLoader built for user content, which is uniquely challenging because you cannot load
/// just posts or just comments, and thus the standard Parent/Child FeedLoader construction does not work without
/// severe API waste. This solution is a simplified variant of that architecture.
///
/// The UserContentFeedLoader is the parent loader. It is responsible for all data fetching, and keeps track of two
/// UserContentStreams, one for Posts and one for Comments. To load a page of items, it consumes the child streams, just as
/// in the standard Parent/Child FeedLoader. To load a new page, however, the stream calls the load method of the
/// UserContentFeedLoader, which performs the call and pushes the results down to the child streams

public class UserContent: Hashable, Equatable, FeedLoadable {
    public typealias FilterType = UserContentFilterType
    
    public let wrappedValue: Value
    
    public enum Value {
        // This always comes from GetPersonDetailsRequest, so we can know we're getting Post2 and Comment2
        case post(Post2)
        case comment(Comment2)
    }
    
    public init(wrappedValue: UserContent.Value) {
        self.wrappedValue = wrappedValue
    }
    
    public func sortVal(sortType: FeedLoaderSort.SortType) -> FeedLoaderSort {
        switch wrappedValue {
        case let .post(post2): post2.sortVal(sortType: sortType)
        case let .comment(comment2): comment2.sortVal(sortType: sortType)
        }
    }
    
    public var actorId: URL {
        switch wrappedValue {
        case let .post(post2): post2.actorId
        case let .comment(comment2): comment2.actorId
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        // TODO: better conformance
        switch wrappedValue {
        case let .post(post2):
            hasher.combine(post2)
            hasher.combine(ContentType.post)
        case let .comment(comment2):
            hasher.combine(comment2)
            hasher.combine(ContentType.comment)
        }
    }
    
    public static func == (lhs: UserContent, rhs: UserContent) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

// This struct is just a convenience wrapper to handle stream state--all loading operations happen at the FeedLoader level to avoid parent/child concurrency control hell
public struct UserContentStream<Item: FeedLoadable> {
    var items: [Item] = .init()
    var cursor: Int = 0
    var doneLoading: Bool = false
    
    var needsMoreItems: Bool { !doneLoading && cursor >= items.count }
    
    mutating func addItems(_ newItems: [Item]) {
        items.append(contentsOf: newItems)
        if newItems.isEmpty {
            doneLoading = true
        }
    }
    
    /// Gets the sort value of the next item in stream for a given sort type without affecting the cursor. Assumes loading has been handled by the FeedLoader.
    /// - Returns: sorting value of the next tracker item corresponding to the given sort type
    /// - Warning: This is NOT a thread-safe function! Only one thread at a time per stream may call this function!
    func nextItemSortVal(sortType: FeedLoaderSort.SortType) async throws -> FeedLoaderSort? {
        guard !doneLoading else {
            return nil
        }
        
        return items[safeIndex: cursor]?.sortVal(sortType: sortType)
    }
    
    /// Gets the next item in the stream and increments the cursor
    /// - Returns: next item in the feed stream
    /// - Warning: This is NOT a thread-safe function! Only one thread at a time per stream may call this function!
    mutating func consumeNextItem() -> UserContent? {
        assert(
            cursor < items.count,
            "consumeNextItem called on a stream without a next item (cursor: \(cursor), count: \(items.count))!"
        )

        if cursor < items.count {
            cursor += 1
            return toParent(item: items[cursor - 1])
        }

        return nil
    }
    
    private func toParent(item: Item) -> UserContent? {
        if let post = item as? Post2 {
            return .init(wrappedValue: .post(post))
        }
        if let comment = item as? Comment2 {
            return .init(wrappedValue: .comment(comment))
        }
        // shouldn't ever get here because we know we're getting either Post2 or Comment2
        assertionFailure("Could not convert to parent or comment!")
        return nil
    }
}

@Observable
public class UserContentFeedLoader: FeedLoading {
    public var api: ApiClient
    public var items: [UserContent]
    public var loadingState: LoadingState
    
    private(set) var sortType: FeedLoaderSort.SortType
    
    /// Last page fetched from the API
    internal var apiPage: Int
    /// Last page of content loaded, used to avoid duplicate loads
    internal var contentPage: Int
    
    private var apiLoadingSemaphore: AsyncSemaphore
    private var contentLoadingSemaphore: AsyncSemaphore
    private var thresholds: (standard: UserContent?, fallback: UserContent?)
    
    var postStream: UserContentStream<Post2>
    var commentStream: UserContentStream<Comment2>
    
    public init(
        api: ApiClient,
        sortType: FeedLoaderSort.SortType
    ) {
        self.api = api
        self.sortType = sortType
        self.apiPage = 0
        self.contentPage = 0
        self.items = .init()
        self.apiLoadingSemaphore = .init(value: 1)
        self.contentLoadingSemaphore = .init(value: 1)
        self.thresholds = (nil, nil)
        self.loadingState = .idle
        self.postStream = .init()
        self.commentStream = .init()
    }
    
    public func loadIfThreshold(_ item: UserContent) throws {
        if thresholds.standard == item || thresholds.fallback == item {
            Task(priority: .userInitiated) {
                try await loadContentPage(contentPage + 1)
            }
        }
    }
    
    public func loadMoreItems() async throws {
        print("Loading more user content")
        try await loadContentPage(contentPage + 1)
    }
    
    public func refresh(clearBeforeRefresh: Bool) async throws {
        self.items = .init()
        self.apiPage = 0
        self.contentPage = 0
        self.postStream = .init()
        self.commentStream = .init()
        try await loadMoreItems()
    }
    
    internal func loadContentPage(_ pageToLoad: Int) async throws {
        await contentLoadingSemaphore.wait()
        defer { contentLoadingSemaphore.signal() }
        
        loadingState = .loading
        
        guard pageToLoad == contentPage + 1 else {
            print("Unexpected content page \(pageToLoad) encountered (expected \(contentPage + 1), skipping load")
            return
        }
        
        contentPage += 1
        var newItems: [UserContent] = .init()
        while newItems.count < 50, loadingState != .done {
            if let nextItem = try await computeNextItem() {
                newItems.append(nextItem)
            } else {
                loadingState = .done
            }
        }
        
        await addItems(newItems)
        
        if loadingState != .done {
            loadingState = .idle
            updateThresholds()
        }
    }
    
    /// Returns the next post or comment, depending on which is sorted first
    internal func computeNextItem() async throws -> UserContent? {
        // if either postStream or commentStream needs items, load
        if postStream.needsMoreItems || commentStream.needsMoreItems {
            try await loadNextApiPage()
        }
        
        let nextPost = try await postStream.nextItemSortVal(sortType: sortType)
        let nextComment = try await commentStream.nextItemSortVal(sortType: sortType)
        
        if let nextPost {
            if let nextComment {
                if nextPost > nextComment {
                    print("Post date \(nextPost) > comment date \(nextComment)")
                } else {
                    print("Comment date \(nextComment) > post date \(nextPost)")
                }
                
                return nextPost > nextComment ? postStream.consumeNextItem() : commentStream.consumeNextItem()
            } else {
                print("No next comment found")
                return postStream.consumeNextItem()
            }
        } else if nextComment != nil {
            print("No next post found")
            return commentStream.consumeNextItem()
        }
        return nil
    }
    
    public func changeSortType(to sortType: FeedLoaderSort.SortType) {
        self.sortType = sortType
        items = .init()
        postStream = .init()
        commentStream = .init()
    }
    
    // MARK: Helpers
    @MainActor
    private func addItems(_ newItems: [UserContent]) {
        items.append(contentsOf: newItems)
    }
    
    internal func fetchItems() async throws -> (posts: [Post2], comments: [Comment2]) {
        preconditionFailure("This method must be implemented by the inheriting class")
    }
    
    /// Loads the next page from the API
    /// - Warning: This is NOT a thread-safe function! It should only be called from a concurrency-controlled environment
    private func loadNextApiPage() async throws {
        apiPage += 1
        let response = try await fetchItems()
        postStream.addItems(response.posts)
        commentStream.addItems(response.comments)
    }
    
    private func updateThresholds() {
        thresholds = (
            standard: items[items.count - 10],
            fallback: items.last
        )
    }
}

public class SavedFeedLoader: UserContentFeedLoader {
    private var userId: Int
    
    // NOTE: must initialize with my user id
    public init(api: ApiClient, sortType: FeedLoaderSort.SortType, userId: Int) {
        self.userId = userId
        super.init(api: api, sortType: sortType)
    }
    
    override func fetchItems() async throws -> (posts: [Post2], comments: [Comment2]) {
        print("Fetching page \(apiPage)")
        return try await api.getContent(authorId: userId, sort: .new, page: apiPage, limit: 50, savedOnly: true)
    }
}
