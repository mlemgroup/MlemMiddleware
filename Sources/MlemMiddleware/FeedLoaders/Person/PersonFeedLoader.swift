//
//  PersonFeedLoader.swift
//
//
//  Created by Sjmarf on 08/09/2024.
//

import Foundation

@Observable
public class PersonFeedLoader: StandardFeedLoader<Person2> {
    public var api: ApiClient
    public private(set) var query: String
    /// `listing` can be set to `.local` from 0.19.4 onwards.
    public private(set) var listing: ApiListingType
    public private(set) var sort: ApiSortType
    
    public init(
        api: ApiClient,
        query: String = "",
        pageSize: Int = 20,
        listing: ApiListingType = .all,
        sort: ApiSortType = .topAll
    ) {
        self.api = api
        self.query = query
        self.listing = listing
        self.sort = sort
        
        super.init(
            pageSize: pageSize,
            filter: .init()
        )
    }
    
    // MARK: StandardTracker Loading Methods
    
    override public func fetchPage(page: Int) async throws -> FetchResponse<Person2> {
        let communities = try await api.searchPeople(
            query: query,
            page: page,
            limit: pageSize,
            filter: listing,
            sort: sort
        )

        return .init(
            items: communities,
            prevCursor: nil,
            nextCursor: nil,
            numFiltered: 0
        )
    }
    
    override public func refresh(clearBeforeRefresh: Bool) async throws {
        try await super.refresh(clearBeforeRefresh: clearBeforeRefresh)
    }
    
    public func refresh(
        query: String? = nil,
        listing: ApiListingType? = nil,
        sort: ApiSortType? = nil,
        clearBeforeRefresh: Bool = false
    ) async throws {
        self.query = query ?? self.query
        self.listing = listing ?? self.listing
        self.sort = sort ?? self.sort
        try await refresh(clearBeforeRefresh: clearBeforeRefresh)
    }
}
