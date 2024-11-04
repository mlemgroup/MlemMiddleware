//
//  AggregatePostFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-07.
//

import Foundation

class AggregatePostFetchProvider: PostFetchProvider {
    var feedType: ApiListingType
    
    init(api: ApiClient, feedType: ApiListingType, sortType: ApiSortType, pageSize: Int) {
        self.feedType = feedType
        
        super.init(api: api, sortType: sortType, pageSize: pageSize)
    }
    
    override internal func getPosts(page: Int, cursor: String?) async throws -> (posts: [Post2], cursor: String?) {
        return try await api.getPosts(
            feed: feedType,
            sort: sortType,
            page: page,
            cursor: cursor,
            limit: pageSize,
            filter: nil, // TODO
            showHidden: false // TODO
        )
    }
}

public class AggregatePostFeedLoader: CorePostFeedLoader {
    public var api: ApiClient
    private(set) var feedType: ApiListingType // ew raw API type but in this case defining a proxy enum seems silly
    
    public init(
        pageSize: Int,
        sortType: ApiSortType,
        showReadPosts: Bool,
        filteredKeywords: [String],
        prefetchingConfiguration: PrefetchingConfiguration,
        urlCache: URLCache,
        api: ApiClient,
        feedType: ApiListingType
    ) {
        self.api = api
        self.feedType = feedType
        super.init(
            api: api,
            pageSize: pageSize,
            showReadPosts: showReadPosts,
            filteredKeywords: filteredKeywords,
            prefetchingConfiguration: prefetchingConfiguration,
            fetchProvider: AggregatePostFetchProvider(
                api: api,
                feedType: feedType,
                sortType: sortType,
                pageSize: pageSize
            )
        )
    }
    
//    override internal func getPosts(page: Int, cursor: String?) async throws -> (posts: [Post2], cursor: String?) {
//        return try await api.getPosts(
//            feed: feedType,
//            sort: sortType,
//            page: page,
//            cursor: cursor,
//            limit: pageSize,
//            filter: nil, // TODO
//            showHidden: false // TODO
//        )
//    }
    
    @MainActor
    public func changeFeedType(to newFeedType: ApiListingType) async throws {
        let shouldRefresh = items.isEmpty || feedType != newFeedType
        
        // always perform assignment--if account changed, feed type will look unchanged but API will be different
        feedType = newFeedType
        
        // only refresh if nominal feed type changed
        if shouldRefresh {
            try await refresh(clearBeforeRefresh: true)
        }
    }
}
