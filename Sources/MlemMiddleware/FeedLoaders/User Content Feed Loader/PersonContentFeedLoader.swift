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

@Observable
public class PersonContentFeedLoader: FeedLoading {
    public var api: ApiClient
    public var items: [PersonContent]
    public var loadingState: LoadingState
    
    // loading configuration
    public private(set) var sortType: FeedLoaderSort.SortType
    private var userId: Int
    private var savedOnly: Bool
    
    // prefetching
    private let smallAvatarIconSize: Int
    private let largeAvatarIconSize: Int
    private let prefetcher: ImagePrefetcher = .init(
        pipeline: ImagePipeline.shared,
        destination: .memoryCache,
        maxConcurrentRequestCount: 40
    )
    
    /// Last page fetched from the API
    internal var apiPage: Int
    /// Last page of content loaded, used to avoid duplicate loads
    internal var contentPage: Int
    
    private var contentLoadingSemaphore: AsyncSemaphore
    private var thresholds: Thresholds<PersonContent> = .init()
    
    private var postStream: PersonContentStream<Post2>
    private var commentStream: PersonContentStream<Comment2>
    
    // these are used to allow refresh without clear
    private var tempPostStream: PersonContentStream<Post2>?
    private var tempCommentStream: PersonContentStream<Comment2>?
    
    var posts: [Post2] { tempPostStream?.items ?? postStream.items }
    var comments: [Comment2] { tempCommentStream?.items ?? commentStream.items }
    
    public init(
        api: ApiClient,
        userId: Int,
        sortType: FeedLoaderSort.SortType,
        savedOnly: Bool,
        smallAvatarSize: CGFloat,
        largeAvatarSize: CGFloat,
        withContent: (posts: [Post2], comments: [Comment2])? = nil
    ) {
        self.api = api
        self.userId = userId
        self.sortType = sortType
        self.savedOnly = savedOnly
        self.apiPage = withContent != nil ? 1 : 0
        self.contentPage = 0
        self.items = .init()
        self.contentLoadingSemaphore = .init(value: 1)
        self.loadingState = .idle
        self.postStream = .init(items: withContent?.posts)
        self.commentStream = .init(items: withContent?.comments)
        self.smallAvatarIconSize = Int(smallAvatarSize * 2)
        self.largeAvatarIconSize = Int(largeAvatarSize * 2)
    }
    
    // MARK: Public Methods
    
    public func switchUser(api: ApiClient, userId: Int) {
        self.api = api
        self.userId = userId
        self.loadingState = .done // prevent loading more items until refresh
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
            case let .post(post): postStream.thresholds.isThreshold(post)
            case let .comment(comment): commentStream.thresholds.isThreshold(comment)
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
        loadingState = .loading
        
        if clearBeforeRefresh {
            items = .init()
        } else {
            tempPostStream = postStream
            tempCommentStream = commentStream
        }
        postStream = .init()
        commentStream = .init()
        apiPage = 0
        contentPage = 0
        defer {
            tempPostStream = nil
            tempCommentStream = nil
        }
        try await loadMoreItems()
    }
    
    public func clear() {
        items = .init()
        postStream = .init()
        commentStream = .init()
        apiPage = 0
        contentPage = 0
        loadingState = .idle
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
        var newItems: [PersonContent] = .init()
        while newItems.count < 50, loadingState != .done {
            if let nextItem = try await computeNextItem() {
                newItems.append(nextItem)
            } else {
                loadingState = .done
            }
        }
        
        if pageToLoad == 1 {
            await setItems(newItems)
        } else {
            await addItems(newItems)
        }
        
        if loadingState != .done {
            loadingState = .idle
            thresholds.update(with: newItems)
        }
    }
    
    /// Returns the next post or comment, depending on which is sorted first
    private func computeNextItem() async throws -> PersonContent? {
        // if either postStream or commentStream needs items, load
        if postStream.needsMoreItems || commentStream.needsMoreItems {
            try await loadNextApiPage()
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
    
    // MARK: Helpers
    
    @MainActor
    private func addItems(_ newItems: [PersonContent]) {
        items.append(contentsOf: newItems)
    }
    
    @MainActor
    private func setItems(_ newItems: [PersonContent]) {
        items = newItems
    }
    
    private func fetchItems() async throws -> (posts: [Post2], comments: [Comment2]) {
        let response = try await api.getContent(authorId: userId, sort: .new, page: apiPage, limit: 50, savedOnly: savedOnly)
        return (posts: response.posts, comments: response.comments)
    }
    
    /// Loads the next page from the API
    /// - Warning: This is NOT a thread-safe function! It should only be called from a concurrency-controlled environment
    private func loadNextApiPage() async throws {
        apiPage += 1
        let response = try await fetchItems()
        preloadImages(response.posts) // TODO: comment images?
        postStream.addItems(response.posts)
        commentStream.addItems(response.comments)
    }
    
    /// Preloads images for the given post
    private func preloadImages(_ posts: [Post2]) {
        prefetcher.startPrefetching(with: posts.flatMap {
            $0.imageRequests(
                smallAvatarIconSize: smallAvatarIconSize,
                largeAvatarIconSize: largeAvatarIconSize)
        })
    }
}
