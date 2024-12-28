//
//  ModlogChildFetcher.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-28.
//  

import Foundation

@Observable
public class ModlogChildFetcher: Fetcher<ModlogEntry> {
    var type: ApiModlogActionType
    
    init(api: ApiClient, pageSize: Int, type: ApiModlogActionType) {
        self.type = type
        super.init(api: api, pageSize: pageSize)
    }
    
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        let items = try await api.getModlog(page: page, limit: pageSize, type: type)
        return .init(
            items: items,
            prevCursor: nil,
            nextCursor: nil
        )
    }
}
