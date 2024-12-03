//
//  AggregatePostFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-07.
//

import Foundation

class AggregatePostFetcher: PostFetcher {
    var feedType: ApiListingType
    
    init(api: ApiClient, pageSize: Int, filter: MultiFilter<Post2>, feedType: ApiListingType, sortType: ApiSortType) {
        self.feedType = feedType
        
        super.init(api: api, pageSize: pageSize, filter: filter, sortType: sortType)
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
    // force unwrap because this should ALWAYS be an AggregatePostFetcher
    var aggregatePostFetcher: AggregatePostFetcher { fetcher as! AggregatePostFetcher }
    
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
        super.init(
            api: api,
            pageSize: pageSize,
            filteredKeywords: filteredKeywords,
            prefetchingConfiguration: prefetchingConfiguration,
            fetcher: AggregatePostFetcher(
                api: api,
                pageSize: pageSize,
                filter: PostFilter(showRead: showReadPosts),
                feedType: feedType,
                sortType: sortType
            )
        )
    }
    
    @MainActor
    public func changeFeedType(to newFeedType: ApiListingType) async throws {
        let shouldRefresh = items.isEmpty || aggregatePostFetcher.feedType != newFeedType
        
        // always perform assignment--if account changed, feed type will look unchanged but API will be different
        aggregatePostFetcher.feedType = newFeedType
        
        // only refresh if nominal feed type changed
        if shouldRefresh {
            try await refresh(clearBeforeRefresh: true)
        }
    }
}
