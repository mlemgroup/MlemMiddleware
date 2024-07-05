//
//  StandardPostFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-01-04.
//

import Foundation
import Nuke
import Observation

/// Post tracker for use with single feeds. Supports all post sorting types, but is not suitable for multi-feed use.
@Observable
public class StandardPostFeedLoader: StandardFeedLoader<Post2> {
    public var feedType: FeedType
    private(set) var postSortType: ApiSortType
    
    // true when the items in the tracker are stale and should not be displayed
    var isStale: Bool = false
    
    // prefetching
    private let prefetcher = ImagePrefetcher(
        pipeline: ImagePipeline.shared,
        destination: .memoryCache,
        maxConcurrentRequestCount: 40
    )
    private let smallAvatarIconSize: Int
    private let largeAvatarIconSize: Int
    private let urlCache: URLCache
    
    public enum FeedType: Equatable {
        case aggregateFeed(any PostFeedProvider, type: ApiListingType)
        case community(any Community)
        
        public static func == (lhs: FeedType, rhs: FeedType) -> Bool {
            switch (lhs, rhs) {
            case let (.aggregateFeed(source1, type: type1), .aggregateFeed(source2, type: type2)):
                return source1.actorId == source2.actorId && type1 == type2
            case let (.community(comm1), .community(comm2)):
                return comm1.actorId == comm2.actorId
            default:
                return false
            }
        }
        
        public func getPosts(
            sort: ApiSortType,
            page: Int = 1,
            cursor: String? = nil,
            limit: Int,
            savedOnly: Bool = false
        ) async throws -> (posts: [Post2], cursor: String?) {
            switch self {
            case let .aggregateFeed(api, type):
                return try await api.getPosts(feed: type, sort: sort, page: page, cursor: cursor, limit: limit, savedOnly: savedOnly)
            case let .community(community):
                return try await community.getPosts(sort: sort, page: page, cursor: cursor, limit: limit, savedOnly: savedOnly)
            }
        }
    }
    
    public init(
        pageSize: Int,
        sortType: ApiSortType,
        showReadPosts: Bool,
        filteredKeywords: [String],
        feedType: FeedType,
        smallAvatarSize: CGFloat,
        largeAvatarSize: CGFloat,
        urlCache: URLCache
    ) {
        self.feedType = feedType
        self.postSortType = sortType
    
        self.smallAvatarIconSize = Int(smallAvatarSize * 2)
        self.largeAvatarIconSize = Int(largeAvatarSize * 2)
        self.urlCache = urlCache
        
        super.init(
            pageSize: pageSize,
            filter: PostFilter(showRead: showReadPosts)
        )
    }
    
    override public func refresh(clearBeforeRefresh: Bool) async throws {
        try await super.refresh(clearBeforeRefresh: clearBeforeRefresh)
    }
    
    // MARK: StandardTracker Loading Methods
    
    override public func fetchPage(page: Int) async throws -> FetchResponse<Post2> {
        let result = try await feedType.getPosts(sort: postSortType, page: page, cursor: nil, limit: pageSize)
        
        let filteredPosts = filter.filter(result.posts)
        preloadImages(filteredPosts)
        return .init(items: filteredPosts, cursor: result.cursor, numFiltered: result.posts.count - filteredPosts.count)
    }
    
    override public func fetchCursor(cursor: String?) async throws -> FetchResponse<Post2> {
        let result = try await feedType.getPosts(sort: postSortType, page: page, cursor: cursor, limit: pageSize)
        
        let filteredPosts = filter.filter(result.posts)
        preloadImages(filteredPosts)
        return .init(items: filteredPosts, cursor: result.cursor, numFiltered: result.posts.count - filteredPosts.count)
    }
    
    // MARK: Custom Behavior
    
    /// Changes the post sort type to the specified value and reloads the feed
    public func changeSortType(to newSortType: ApiSortType, forceRefresh: Bool = false) async throws {
        // don't do anything if sort type not changed
        guard postSortType != newSortType || forceRefresh else {
            return
        }
        
        postSortType = newSortType
        try await refresh(clearBeforeRefresh: true)
    }
    
    @MainActor
    public func changeFeedType(to newFeedType: FeedType) async throws {
        let feedTypeChanged = feedType != newFeedType
        
        // always perform assignment--if account changed, feed type will look unchanged but API will be different
        feedType = newFeedType
        
        // only refresh if nominal feed type changed
        if feedTypeChanged {
            try await refresh(clearBeforeRefresh: true)
        }
    }
    
    /// Adds a filter to the tracker, removing all current posts that do not pass the filter and filtering out all future posts that do not pass the filter.
    /// Use in situations where filtering is handled client-side (e.g., filtering read posts or keywords)
    /// - Parameter newFilter: NewPostFilterReason describing the filter to apply
    public func addFilter(_ newFilter: PostFilterType) async throws {
        if filter.activate(newFilter) {
            await setItems(filter.reset(with: items))
            
            if items.isEmpty {
                try await refresh(clearBeforeRefresh: false)
            }
        }
    }
    
    public func removeFilter(_ filterToRemove: PostFilterType) async throws {
        if filter.deactivate(filterToRemove) {
            try await refresh(clearBeforeRefresh: true)
        }
    }
    
    public func getFilteredCount(for toCount: PostFilterType) -> Int {
        return filter.numFiltered(for: toCount)
    }
    
    private func preloadImages(_ newPosts: [Post2]) {
        URLSession.shared.configuration.urlCache = urlCache
        var imageRequests: [ImageRequest] = []
        for post in newPosts {
            // preload user and community avatars--fetching both because we don't know which we'll need, but these are super tiny
            // so it's probably not an API crime, right?
            if let communityAvatarLink = post.community.avatar {
                imageRequests.append(ImageRequest(url: communityAvatarLink.withIconSize(smallAvatarIconSize)))
            }
            
            if let userAvatarLink = post.creator.avatar {
                imageRequests.append(ImageRequest(url: userAvatarLink.withIconSize(largeAvatarIconSize * 2)))
            }
            
            switch post.type {
            case let .image(url):
                // images: only load the image
                imageRequests.append(ImageRequest(url: url, priority: .high))
            case let .link(url):
                // websites: load image and favicon
                if let baseURL = post.linkUrl?.host,
                   let favIconURL = URL(string: "https://www.google.com/s2/favicons?sz=64&domain=\(baseURL)") {
                    imageRequests.append(ImageRequest(url: favIconURL))
                }
                if let url {
                    imageRequests.append(ImageRequest(url: url, priority: .high))
                }
            default:
                break
            }
        }
        
        prefetcher.startPrefetching(with: imageRequests)
    }
}
