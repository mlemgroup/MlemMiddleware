//
//  CommunityFeedLoader.swift
//
//
//  Created by Sjmarf on 08/09/2024.
//

import Foundation

class CommunityFetchProvider: FetchProviding {
    typealias Item = Community2
    
    let api: ApiClient
    var query: String
    var pageSize: Int
    var listing: ApiListingType
    var sort: ApiSortType
    
    init(api: ApiClient, query: String, pageSize: Int, listing: ApiListingType, sort: ApiSortType) {
        self.api = api
        self.query = query
        self.pageSize = pageSize
        self.listing = listing
        self.sort = sort
    }
    
    func fetchPage(_ page: Int) async throws -> FetchResponse<Community2> {
        let communities = try await api.searchCommunities(
            query: query,
            page: page,
            limit: pageSize,
            filter: listing,
            sort: sort
        )
        
        return FetchResponse<Community2>.init(
            items: communities,
            prevCursor: nil,
            nextCursor: nil
        )
    }
    
    func fetchCursor(_ cursor: String) async throws -> FetchResponse<Community2> {
        fatalError("Unsupported loading operation")
    }
}

@Observable
public class CommunityFeedLoader: StandardFeedLoader<Community2> {
    public var api: ApiClient
//    public private(set) var query: String
//    public private(set) var listing: ApiListingType
//    public private(set) var sort: ApiSortType
    
    public init(
        api: ApiClient,
        query: String = "",
        pageSize: Int = 20,
        listing: ApiListingType = .all,
        sort: ApiSortType = .topAll
    ) {
        self.api = api
//        self.query = query
//        self.listing = listing
//        self.sort = sort
        
        super.init(
            filter: .init(),
            fetchProvider: CommunityFetchProvider(
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
        guard let communityFetchProvider = fetchProvider as? CommunityFetchProvider else {
            assertionFailure("fetchProvider is not CommunityFetchProvider")
            return
        }
        
        communityFetchProvider.query = query ?? communityFetchProvider.query
        communityFetchProvider.listing = listing ?? communityFetchProvider.listing
        communityFetchProvider.sort = sort ?? communityFetchProvider.sort
        try await refresh(clearBeforeRefresh: clearBeforeRefresh)
    }
}
