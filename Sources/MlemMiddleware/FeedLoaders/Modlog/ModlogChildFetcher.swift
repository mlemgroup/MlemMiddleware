//
//  ModlogChildFetcher.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-28.
//  

import Foundation

@Observable
public class ModlogChildFetcher: Fetcher<ModlogEntry> {
    let sharedCache: SharedCache
    var type: ApiModlogActionType
    
    init(
        api: ApiClient,
        pageSize: Int,
        sharedCache: SharedCache,
        type: ApiModlogActionType
    ) {
        self.type = type
        self.sharedCache = sharedCache
        super.init(api: api, pageSize: pageSize)
    }
    
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        let items: [ModlogEntry]
        if page == 1 {
            items = try await sharedCache.get(type: type)
        } else {
            items = try await api.getModlog(page: page, limit: pageSize, type: type)
        }
        
        return .init(
            items: items,
            prevCursor: nil,
            nextCursor: nil
        )
    }
}
