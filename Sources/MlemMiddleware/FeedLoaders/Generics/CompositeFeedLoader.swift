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

public enum UserContent {
    // This always comes from GetPersonDetailsRequest, so we can know we're getting Post2 and Comment2
    case post(Post2)
    case comment(Comment2)
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
            return .post(post)
        }
        if let comment = item as? Comment2 {
            return .comment(comment)
        }
        // shouldn't ever get here because we know we're getting either Post2 or Comment2
        assertionFailure("Could not convert to parent or comment!")
        return nil
    }
}

public class UserContentFeedLoader {
    public var api: ApiClient
    private(set) var sortType: FeedLoaderSort.SortType
    internal var page: Int
    public var items: [UserContent]
    private var loadingSempahore: AsyncSemaphore
    private var thresholds: (UserContent?, UserContent?)
    
    // These are lazy so that we can pass loadMoreItems in at init
    lazy var postStream: UserContentStream<Post2> = .init(sortType: sortType, load: self.fetchItems)
    lazy var commentStream: UserContentStream<Comment2> = .init(sortType: sortType, load: self.fetchItems)
    
    init(
        api: ApiClient,
        sortType: FeedLoaderSort.SortType
    ) {
        self.api = api
        self.sortType = sortType
        self.page = 1
        self.items = .init()
        self.loadingSempahore = .init(value: 1)
        self.thresholds = (nil, nil)
    }
    
    public func loadIfThreshold(item: UserContent) {
        
    }
    
    func loadPage(_ pageToLoad: Int) async throws {
        await loadingSempahore.wait()
        defer { loadingSempahore.signal() }
        
        if pageToLoad != page + 1 {
            print("Unexpected page \(pageToLoad) encountered (expected \(page + 1)), skipping load")
            return
        }
        
        try await fetchItems()
        page += 1
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
}

public class SavedFeedLoader: UserContentFeedLoader {
    private var userId: Int
    
    // NOTE: must initialize with my user id
    init(api: ApiClient, sortType: FeedLoaderSort.SortType, userId: Int) {
        self.userId = userId
        super.init(api: api, sortType: sortType)
    }
    
    override func fetchItems() async throws {
        let response = try await api.getContent(authorId: userId, sort: .new, page: page, limit: 50, savedOnly: true)
        postStream.addItems(response.posts)
        commentStream.addItems(response.comments)
    }
}
