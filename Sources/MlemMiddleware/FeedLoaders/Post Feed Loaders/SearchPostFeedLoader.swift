//
//  SearchPostFeedLoader.swift
//  MlemMiddleware
//
//  Created by Sam Marfleet on 04/10/2024.
//

import Foundation

public class SearchPostFetchProvider: PostFetchProvider {
    public var query: String
    public var communityId: Int?
    public var creatorId: Int?
    public var listing: ApiListingType
    
    // setters to allow manual overriding of these for search use cases
    public func setApi(_ api: ApiClient) { self.api = api }
    public func setSortType(_ sortType: ApiSortType) { self.sortType = sortType }
    
    init(api: ApiClient, sortType: ApiSortType, pageSize: Int, query: String, communityId: Int?, creatorId: Int?, listing: ApiListingType) {
        self.query = query
        self.communityId = communityId
        self.creatorId = creatorId
        self.listing = listing
        
        super.init(api: api, sortType: sortType, pageSize: pageSize)
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

public class SearchPostFeedLoader: CorePostFeedLoader {
    
    // force unwrap because this should ALWAYS be a SearchPostFetchProvider
    public var searchPostFetchProvider: SearchPostFetchProvider { fetchProvider as! SearchPostFetchProvider }
    
    public init(
        preheat: Bool,
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
        super.init(
            preheat: preheat,
            api: api,
            pageSize: pageSize,
            showReadPosts: true,
            filteredKeywords: filteredKeywords,
            prefetchingConfiguration: prefetchingConfiguration,
            fetchProvider: SearchPostFetchProvider(
                api: api,
                sortType: sortType,
                pageSize: pageSize,
                query: query,
                communityId: communityId,
                creatorId: creatorId,
                listing: listing
            )
        )
    }
}
