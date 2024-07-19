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

// This is basically a ChildTracker minus post loading
public struct UserContentStream<Item: FeedLoadable> {
    var items: [Item] = .init()
    var cursor: Int = 0
    var doneLoading: Bool = false
    let sortType: FeedLoaderSort.SortType
    
    /// This function is passed in from UserContentFeedLoader, and triggers a load on UserContentFeedLoader.
    var load: () async throws -> Void
    
    init(
        sortType: FeedLoaderSort.SortType,
        load: @escaping () async throws -> Void
    ) {
        self.sortType = sortType
        self.load = load
    }
    
    mutating func addItems(_ newItems: [Item]) {
        items.append(contentsOf: newItems)
        if newItems.isEmpty {
            doneLoading = true
        }
    }
    
    /// Gets the sort value of the next item in stream for a given sort type without affecting the cursor.
    /// - Returns: sorting value of the next tracker item corresponding to the given sort type
    /// - Warning: This is NOT a thread-safe function! Only one thread at a time per stream may call this function!
    func nextItemSortVal() async throws -> FeedLoaderSort? {
        assert(sortType == self.sortType, "Conflicting types for sortType! This should not be possible!")
        
        if cursor < items.count {
            return items[cursor].sortVal(sortType: sortType)
        }
        
        // if done loading, return nil
        guard !doneLoading else {
            return nil
        }
        
        // otherwise, wait for the next page to load and try to return the first value
        // if the next page is already loading, this call to loadNextPage will be noop, but still wait until that load completes thanks to the semaphore
        try await load()
        return cursor < items.count ? items[cursor].sortVal(sortType: sortType) : nil
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
    
    // These are lazy so that we can pass loadMoreItems in at init
    lazy var postStream: UserContentStream<Post2> = .init(sortType: sortType, load: self.fetchItems)
    lazy var commentStream: UserContentStream<Comment2> = .init(sortType: sortType, load: self.fetchItems)
    
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
        await contentLoadingSemaphore.wait()
        await apiLoadingSemaphore.wait()
        defer {
            contentLoadingSemaphore.signal()
            apiLoadingSemaphore.signal()
        }
        
        self.items = .init()
        self.apiPage = 0
        self.contentPage = 0
        self.postStream = .init(sortType: sortType, load: self.fetchItems)
        self.commentStream = .init(sortType: sortType, load: self.fetchItems)
        try await loadMoreItems()
    }
    
    internal func loadContentPage(_ pageToLoad: Int) async throws {
        await contentLoadingSemaphore.wait()
        defer { contentLoadingSemaphore.signal() }
        
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
            updateThresholds()
        }
    }
    
    func loadApiPage(_ pageToLoad: Int) async throws {
        await apiLoadingSemaphore.wait()
        defer { apiLoadingSemaphore.signal() }
        
        guard pageToLoad == apiPage + 1 else {
            print("Unexpected API page \(pageToLoad) encountered (expected \(apiPage + 1)), skipping load")
            return
        }
        
        apiPage += 1
        try await fetchItems()
    }
    
    func fetchItems() async throws {
        preconditionFailure("This method must be implemented by the inheriting class")
    }
    
    /// Returns the next post or comment, depending on which is sorted first
    internal func computeNextItem() async throws -> UserContent? {
        let nextPost = try await postStream.nextItemSortVal()
        let nextComment = try await commentStream.nextItemSortVal()
        
        if let nextPost {
            if let nextComment {
                return nextPost > nextComment ? postStream.consumeNextItem() : commentStream.consumeNextItem()
            } else {
                return postStream.consumeNextItem()
            }
        } else if nextComment != nil {
            return commentStream.consumeNextItem()
        }
        return nil
    }
    
    public func changeSortType(to sortType: FeedLoaderSort.SortType) {
        self.sortType = sortType
        items = .init()
        postStream = .init(sortType: sortType, load: fetchItems)
        commentStream = .init(sortType: sortType, load: fetchItems)
    }
    
    // MARK: Helpers
    @MainActor
    private func addItems(_ newItems: [UserContent]) {
        items.append(contentsOf: newItems)
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
    
    override func fetchItems() async throws {
        let response = try await api.getContent(authorId: userId, sort: .new, page: apiPage, limit: 50, savedOnly: true)
        postStream.addItems(response.posts)
        commentStream.addItems(response.comments)
    }
}
