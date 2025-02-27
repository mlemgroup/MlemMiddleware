//
//  SearchPostFeedLoader.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 04/10/2024.
//

import Foundation

@Observable
public class SearchPostFetcher: Fetcher<Post2> {
    public var query: String
    public var communityId: Int?
    public var creatorId: Int?
    public var sortType: ApiSortType
    public var listing: ApiListingType
    
    // setters to allow manual overriding of these for search use cases
    public override func changeApi(to newApi: ApiClient, context: FilterContext) async {
        await super.changeApi(to: newApi, context: context)
    }
    public func setSortType(_ sortType: ApiSortType) { self.sortType = sortType }
    
    init(api: ApiClient, sortType: ApiSortType, pageSize: Int, query: String, communityId: Int?, creatorId: Int?, listing: ApiListingType) {
        self.query = query
        self.communityId = communityId
        self.creatorId = creatorId
        self.listing = listing
        
        super.init(api: api, pageSize: pageSize)
    }
    
    override internal func fetchPage(_ page: Int) async throws -> Fetcher<Post2>.FetchResponse {
        let response = try await api.searchPosts(
            query: query,
            page: page,
            limit: pageSize,
            communityId: communityId,
            creatorId: creatorId,
            filter: listing,
            sort: sortType
        )
        return .init(items: response, prevCursor: nil, nextCursor: nil)
    }
}

public class SearchPostFeedLoader: CorePostFeedLoader {
    
    // force unwrap because this should ALWAYS be a SearchPostFetcher
    public var searchPostFetcher: SearchPostFetcher { fetcher as! SearchPostFetcher }
    
    public init(
        api: ApiClient,
        query: String = "",
        pageSize: Int = 20,
        sortType: ApiSortType = .topAll,
        creatorId: Int? = nil,
        communityId: Int? = nil,
        prefetchingConfiguration: PrefetchingConfiguration,
        urlCache: URLCache,
        listing: ApiListingType = .all
    ) {
        super.init(
            showReadPosts: true,
            filterContext: .none(), // search doesn't filter, only obscures on the frontend
            prefetchingConfiguration: prefetchingConfiguration,
            fetcher: SearchPostFetcher(
                api: api,
                sortType: sortType,
                pageSize: pageSize,
                query: query,
                communityId: communityId,
                creatorId: creatorId,
                listing: listing
            )
        )
        loadingState = .idle
    }
}
