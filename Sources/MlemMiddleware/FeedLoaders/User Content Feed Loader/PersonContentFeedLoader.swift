//
//  PersonContentFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-09.
//

import Foundation
import Semaphore
import Nuke

/// This is a special type of FeedLoader built for user content, which is uniquely challenging because you cannot load
/// just posts or just comments, and thus the standard Parent/Child FeedLoader construction does not work without
/// severe API waste. This solution is a simplified variant of that architecture.
///
/// The PersonContentFeedLoader is the parent loader. It is responsible for all data fetching, and keeps track of two
/// PersonContentStreams, one for Posts and one for Comments. To load a page of items, it consumes and merges the child streams, just as
/// in the standard Parent/Child FeedLoader; if either stream reaches the end of its items, it triggers a new load, the response from
/// which is then incorporated into both child streams.

class PersonContentFetcher: Fetcher {
    typealias Item = PersonContent
    
    var api: ApiClient
    var pageSize: Int
    var sortType: FeedLoaderSort.SortType
    var userId: Int
    var savedOnly: Bool
    
    var postStream: PersonContentStream<Post2>
    var commentStream: PersonContentStream<Comment2>
    
    private var apiPage: Int
    
    init(api: ApiClient, pageSize: Int, sortType: FeedLoaderSort.SortType, userId: Int, savedOnly: Bool, withContent: (posts: [Post2], comments: [Comment2])?) {
        self.api = api
        self.pageSize = pageSize
        self.sortType = sortType
        self.userId = userId
        self.savedOnly = savedOnly
        self.postStream = .init(items: withContent?.posts)
        self.commentStream = .init(items: withContent?.comments)
        self.apiPage = withContent == nil ? 0 : 1
    }
    
    // TODO: make this a Fetcher function
    func reset() {
        apiPage = 0
        postStream = .init()
        commentStream = .init()
    }
    
    func fetchPage(_ page: Int) async throws -> FetchResponse<PersonContent> {
        // TODO: remove page parameter, make Fetcher implement fetch() by default and track pages
        var newItems: [PersonContent] = .init()
        
        repeat {
            if let nextItem = try await computeNextItem() {
                newItems.append(nextItem)
            } else {
                break
            }
        } while newItems.count < pageSize
        
        return .init(items: newItems, prevCursor: nil, nextCursor: nil)
    }
    
    func fetchCursor(_ cursor: String) async throws -> FetchResponse<PersonContent> {
        fatalError("Unsupported loading operation")
    }
    
    /// Returns the next post or comment, depending on which is sorted first
    private func computeNextItem() async throws -> PersonContent? {
        // if either postStream or commentStream needs items, load the next page from the API
        if postStream.needsMoreItems || commentStream.needsMoreItems {
            apiPage += 1
            let response = try await api.getContent(authorId: userId, sort: .new, page: apiPage, limit: 50, savedOnly: savedOnly)
            postStream.addItems(response.posts)
            commentStream.addItems(response.comments)
        }
        
        let nextPost = try await postStream.nextItemSortVal(sortType: sortType)
        let nextComment = try await commentStream.nextItemSortVal(sortType: sortType)
        
        if let nextPost {
            if let nextComment {
                // if both next post and next comment, return higher sort
                return nextPost > nextComment ? postStream.consumeNextItem() : commentStream.consumeNextItem()
            } else {
                // if next post but no next comment, return next post
                return postStream.consumeNextItem()
            }
        }
        
        // if no next post, always return next comment (this returns nil if no next comment)
        return commentStream.consumeNextItem()
    }
}

@Observable
public class PersonContentFeedLoader: FeedLoading {
    // public var api: ApiClient
    public var items: [PersonContent]
    public var loadingState: LoadingState
    
    public var prefetchingConfiguration: PrefetchingConfiguration
    
    let fetcher: PersonContentFetcher

    private var thresholds: Thresholds<PersonContent> = .init()
    
    private var postStream: PersonContentStream<Post2> { fetcher.postStream }
    private var commentStream: PersonContentStream<Comment2> { fetcher.commentStream }
    
    // these are used to allow refresh without clear
    private var tempPostStream: PersonContentStream<Post2>?
    private var tempCommentStream: PersonContentStream<Comment2>?
    
    // convenience accessors for child types
    public var posts: [PersonContent] { tempPostStream?.items ?? postStream.items }
    public var postLoadingState: LoadingState { postStream.doneLoading ? .done : loadingState }
    
    public var comments: [PersonContent] { tempCommentStream?.items ?? commentStream.items }
    public var commentLoadingState: LoadingState { commentStream.doneLoading ? .done : loadingState }
    
    public init(
        api: ApiClient,
        userId: Int,
        sortType: FeedLoaderSort.SortType,
        savedOnly: Bool,
        prefetchingConfiguration: PrefetchingConfiguration,
        withContent: (posts: [Post2], comments: [Comment2])? = nil
    ) {
        self.items = .init()
        self.loadingState = .loading
        self.fetcher = .init(api: api, sortType: sortType, userId: userId, savedOnly: savedOnly, withContent: withContent)
        self.prefetchingConfiguration = prefetchingConfiguration
    }
    
    // MARK: Public Methods
    
    public func switchUser(api: ApiClient, userId: Int) async {
        // self.api = api
        // self.userId = userId
        fetcher.api = api
        fetcher.userId = userId
        await setLoadingState(.done) // prevent loading more items until refresh
    }
    
    // protocol conformance
    public func loadIfThreshold(_ item: PersonContent) throws {
        try loadIfThreshold(item, asChild: false)
    }
    
    /// Given a PersonContent, loads more items if that content is a threshold item
    /// - Parameters:
    ///   - item: PersonContent
    ///   - loadChildOnly: if true, the item will be evaluated against the relevant stream threshold rather than the parent threshold
    public func loadIfThreshold(_ item: PersonContent, asChild: Bool) throws {
        let shouldLoad: Bool
        if asChild {
            shouldLoad = switch item.wrappedValue {
            case .post: postStream.thresholds.isThreshold(item)
            case .comment: commentStream.thresholds.isThreshold(item)
            }
        } else {
            shouldLoad = thresholds.isThreshold(item)
        }
        
        // regardless of which threshold triggers this, always call loadMoreItems() because there's no item-specific endpoint
        if shouldLoad {
            Task(priority: .userInitiated) {
                try await loadMoreItems()
            }
        }
    }
    
    public func loadMoreItems() async throws {
        // TODO: implement with LoadingActor
        // print("Loading more user content")
        // try await loadContentPage(contentPage + 1)
    }
    
    public func changeSortType(to sortType: FeedLoaderSort.SortType) {
        items = .init()
        fetcher.sortType = sortType
        fetcher.postStream = .init()
        fetcher.commentStream = .init()
    }
    
    public func refresh(clearBeforeRefresh: Bool) async throws {
        await setLoadingState(.loading)
        
        if clearBeforeRefresh {
            items = .init()
        } else {
            tempPostStream = postStream
            tempCommentStream = commentStream
        }
        fetcher.reset()
        defer {
            tempPostStream = nil
            tempCommentStream = nil
        }
        try await loadMoreItems()
    }
    
    @MainActor
    public func clear() {
        items = .init()]
        tempPostStream = nil
        tempCommentStream = nil
        fetcher.reset()
        loadingState = .idle
    }
    
    // MARK: Private Methods
    
    // MARK: Helpers
    
    @MainActor
    private func setLoadingState(_ newState: LoadingState) {
        loadingState = newState
    }
    
    @MainActor
    private func addItems(_ newItems: [PersonContent]) {
        items.append(contentsOf: newItems)
    }
    
    @MainActor
    private func setItems(_ newItems: [PersonContent]) {
        items = newItems
    }
    /// Preloads images for the given post
    private func preloadImages(_ posts: [Post2]) {
        prefetchingConfiguration.prefetcher.startPrefetching(with: posts.flatMap {
            $0.imageRequests(configuration: prefetchingConfiguration)
        })
    }
}
