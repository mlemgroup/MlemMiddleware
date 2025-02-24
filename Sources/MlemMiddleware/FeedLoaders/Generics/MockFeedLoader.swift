//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-23.
//  

import Foundation

@Observable
public class MockFeedLoader<Item: FeedLoadable>: StandardFeedLoader<Item> {
    public init( api: MockApiClient = .mock, items: [Item]) {
        super.init(
            filter: .init(), fetcher: MockFetcher(api: api, pageSize: 5)
        )
        self.items = items
        self.loadingState = .done
    }
}

@Observable
private class MockFetcher<Item: FeedLoadable>: Fetcher<Item> {
    init(api: MockApiClient, pageSize: Int) {
        super.init(api: api, pageSize: pageSize)
    }
    
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        .init(
            items: [],
            prevCursor: nil,
            nextCursor: nil
        )
    }
}
