//
//  CommunityFeedLoader.swift
//
//
//  Created by Sjmarf on 08/09/2024.
//

import Foundation

class CommunityFetcher: Fetcher<Community2> {
    let api: ApiClient
    var query: String
    var listing: ApiListingType
    var sort: ApiSortType
    
    init(api: ApiClient, query: String, pageSize: Int, listing: ApiListingType, sort: ApiSortType) {
        self.api = api
        self.query = query
        self.listing = listing
        self.sort = sort
        
        super.init(pageSize: pageSize)
    }
    
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        let communities = try await api.searchCommunities(
            query: query,
            page: page,
            limit: pageSize,
            filter: listing,
            sort: sort
        )
        
        return .init(
            items: communities,
            prevCursor: nil,
            nextCursor: nil
        )
    }
}

@Observable
public class CommunityFeedLoader: StandardFeedLoader<Community2> {
    public var api: ApiClient
    
    // force unwrap because this should ALWAYS be a CommunityFetcher
    var communityFetcher: CommunityFetcher { fetcher as! CommunityFetcher }
    
    public init(
        api: ApiClient,
        query: String = "",
        pageSize: Int = 20,
        listing: ApiListingType = .all,
        sort: ApiSortType = .topAll
    ) {
        self.api = api

        super.init(
            filter: .init(),
            fetcher: CommunityFetcher(
                api: api,
                query: query,
                pageSize: pageSize,
                listing: listing,
                sort: sort)
        )
    }
    
    public func refresh(
        query: String? = nil,
        listing: ApiListingType? = nil,
        sort: ApiSortType? = nil,
        clearBeforeRefresh: Bool = false
    ) async throws {
        communityFetcher.query = query ?? communityFetcher.query
        communityFetcher.listing = listing ?? communityFetcher.listing
        communityFetcher.sort = sort ?? communityFetcher.sort
        try await refresh(clearBeforeRefresh: clearBeforeRefresh)
    }
}
