//
//  CompositeFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-09.
//

import Foundation

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
    var loadingState: LoadingState = .idle
    let sortType: FeedLoaderSortType
    
    /// This function is passed in from UserContentFeedLoader, and triggers a load on UserContentFeedLoader.
    var load: () async -> Void
    
    init(
        sortType: FeedLoaderSortType,
        load: @escaping () async -> Void
    ) {
        self.sortType = sortType
        self.load = load
    }
    
    mutating func addItems(_ newItems: [Item]) {
        items.append(contentsOf: newItems)
    }
    
    /// Gets the sort value of the next item in stream for a given sort type without affecting the cursor.
    /// - Returns: sorting value of the next tracker item corresponding to the given sort type
    /// - Warning: This is NOT a thread-safe function! Only one thread at a time per stream may call this function!
    func nextItemSortVal() async throws -> FeedLoaderSortVal? {
        assert(sortType == self.sortType, "Conflicting types for sortType! This should not be possible!")
        
        if cursor < items.count {
            return items[cursor].sortVal(sortType: sortType)
        }
        
        // if done loading, return nil
        if loadingState == .done {
            return nil
        }
        
        // otherwise, wait for the next page to load and try to return the first value
        // if the next page is already loading, this call to loadNextPage will be noop, but still wait until that load completes thanks to the semaphore
        await load()
        return cursor < items.count ? items[cursor].sortVal(sortType: sortType) : nil
    }
}

public class UserContentFeedLoader {
    public var api: ApiClient
    private(set) var sortType: FeedLoaderSortType
    
    // These are lazy so that we can pass loadMoreItems in at init
    private(set) lazy var postStream: UserContentStream<Post2> = .init(sortType: sortType, load: self.loadMoreItems)
    private(set) lazy var commentStream: UserContentStream<Comment2> = .init(sortType: sortType, load: self.loadMoreItems)
    
    init(
        api: ApiClient,
        sortType: FeedLoaderSortType
    ) {
        self.api = api
        self.sortType = sortType
    }
    
    func loadMoreItems() async {
        print("TODO")
    }
    
    func changeSortType(to sortType: ApiSortType) {
        print("TODO")
        // needs to re-initialize children with new sort type
    }
}
