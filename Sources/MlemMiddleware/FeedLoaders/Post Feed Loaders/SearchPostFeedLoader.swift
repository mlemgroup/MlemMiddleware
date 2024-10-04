//
//  SearchPostFeedLoader.swift
//  MlemMiddleware
//
//  Created by Sam Marfleet on 04/10/2024.
//

import Foundation

public class SearchPostFeedLoader: CorePostFeedLoader {
    public var api: ApiClient
    public var query: String
    public var listing: ApiListingType
    
    public init(
        api: ApiClient,
        query: String = "",
        pageSize: Int = 20,
        sortType: ApiSortType = .topAll,
        filteredKeywords: [String] = [],
        prefetchingConfiguration: PrefetchingConfiguration,
        urlCache: URLCache,
        listing: ApiListingType = .all
    ) {
        self.api = api
        self.query = query
        self.listing = listing
        super.init(
            pageSize: pageSize,
            sortType: sortType,
            showReadPosts: true,
            filteredKeywords: filteredKeywords,
            prefetchingConfiguration: prefetchingConfiguration
        )
    }
    
    override internal func getPosts(page: Int, cursor: String?) async throws -> (posts: [Post2], cursor: String?) {
        let response = try await api.searchPosts(
            query: query,
            page: page,
            limit: pageSize,
            communityId: nil,
            creatorId: nil,
            filter: listing,
            sort: sortType
        )
        return (posts: response, cursor: nil)
    }
}
