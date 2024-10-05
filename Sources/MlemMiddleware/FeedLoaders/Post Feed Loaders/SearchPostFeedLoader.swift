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
    public var creatorId: Int?
    public var communityId: Int?
    
    public init(
        api: ApiClient,
        query: String = "",
        pageSize: Int = 20,
        sortType: ApiSortType = .topAll,
        creatorId: Int? = nil,
        communityId: Int? = nil,
        filteredKeywords: [String] = [],
        prefetchingConfiguration: PrefetchingConfiguration,
        urlCache: URLCache,
        listing: ApiListingType = .all
    ) {
        self.api = api
        self.query = query
        self.listing = listing
        self.creatorId = creatorId
        self.communityId = communityId
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
            communityId: communityId,
            creatorId: creatorId,
            filter: listing,
            sort: sortType
        )
        return (posts: response, cursor: nil)
    }
}
