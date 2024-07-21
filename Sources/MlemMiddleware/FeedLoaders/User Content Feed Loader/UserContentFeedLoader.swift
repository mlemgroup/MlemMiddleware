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

@Observable
public class UserContentFeedLoader: FeedLoading {
    public var api: ApiClient
    public var items: [UserContent]
    public var loadingState: LoadingState
    
    // loading configuration
    private(set) var sortType: FeedLoaderSort.SortType
    private var userId: Int
    private var savedOnly: Bool
    
    /// Last page fetched from the API
    internal var apiPage: Int
    /// Last page of content loaded, used to avoid duplicate loads
    internal var contentPage: Int
    
    private var contentLoadingSemaphore: AsyncSemaphore
    private var thresholds: (standard: UserContent?, fallback: UserContent?)
    
    var postStream: UserContentStream<Post2>
    var commentStream: UserContentStream<Comment2>
    
    public init(
        api: ApiClient,
        userId: Int,
        sortType: FeedLoaderSort.SortType,
        savedOnly: Bool
    ) {
        self.api = api
        self.userId = userId
        self.sortType = sortType
        self.savedOnly = savedOnly
        self.apiPage = 0
        self.contentPage = 0
        self.items = .init()
        self.contentLoadingSemaphore = .init(value: 1)
        self.thresholds = (nil, nil)
        self.loadingState = .idle
        self.postStream = .init()
        self.commentStream = .init()
    }
    
    // MARK: Public Methods
    
    public func loadIfThreshold(_ item: UserContent) throws {
        if thresholds.standard == item || thresholds.fallback == item {
            Task(priority: .userInitiated) {
                try await loadMoreItems()
            }
        }
    }
    
    public func loadMoreItems() async throws {
        print("Loading more user content")
        try await loadContentPage(contentPage + 1)
    }
    
    public func changeSortType(to sortType: FeedLoaderSort.SortType) {
        self.sortType = sortType
        items = .init()
        postStream = .init()
        commentStream = .init()
    }
    
    public func refresh(clearBeforeRefresh: Bool) async throws {
        self.items = .init()
        self.apiPage = 0
        self.contentPage = 0
        self.postStream = .init()
        self.commentStream = .init()
        try await loadMoreItems()
    }
    
    // MARK: Private Methods
    
    private func loadContentPage(_ pageToLoad: Int) async throws {
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
    private func computeNextItem() async throws -> UserContent? {
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
    
    // MARK: Helpers
    
    @MainActor
    private func addItems(_ newItems: [UserContent]) {
        items.append(contentsOf: newItems)
    }
    
    private func fetchItems() async throws -> (posts: [Post2], comments: [Comment2]) {
        return try await api.getContent(authorId: userId, sort: .new, page: apiPage, limit: 50, savedOnly: savedOnly)
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
