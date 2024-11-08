//
//  PersonFeedLoader.swift
//
//
//  Created by Sjmarf on 08/09/2024.
//

import Foundation

struct PersonFetcher: Fetcher {
    typealias item = Person2
    
    let api: ApiClient
    let query: String
    let pageSize: Int
    let listing: ApiListingType
    let sort: ApiSortType
    
    func fetchPage(_ page: Int) async throws -> FetchResponse<Person2> {
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
            nextCursor: nil
        )
    }
    
    func fetchCursor(_ cursor: String) async throws -> FetchResponse<Person2> {
        fatalError("Unsupported loading operation")
    }
}

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
            filter: .init(),
            fetcher: PersonFetcher(api: api, query: query, pageSize: pageSize, listing: listing, sort: sort)
        )
    }
    
    // MARK: StandardTracker Loading Methods
    
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
