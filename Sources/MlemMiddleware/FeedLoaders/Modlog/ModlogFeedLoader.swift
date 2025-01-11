//
//  ModlogFeedLoader.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-28.
//  

import Foundation

public class ModlogFeedLoader: StandardFeedLoader<ModlogEntry> {
    var modlogFetcher: MultiFetcher<ModlogEntry> { fetcher as! MultiFetcher }
    
    var modlogSources: [ModlogChildFeedLoader] {
        (modlogFetcher.sources as? [ModlogChildFeedLoader])!
    }
    
    private var sharedCache: ModlogChildFetcher.SharedCache
    
    public init(
        api: ApiClient,
        pageSize: Int,
        communityId: Int?,
        sortType: FeedLoaderSort.SortType
    ) {
        let sharedCache: ModlogChildFetcher.SharedCache = .init(api: api, pageSize: pageSize, communityId: communityId)
        self.sharedCache = sharedCache
        
        let sources: [ModlogChildFeedLoader] = ApiModlogActionType.allFilteredCases.map { type in
                .init(
                    api: api,
                    sortType: sortType,
                    fetcher: .init(
                        api: api,
                        pageSize: pageSize,
                        sharedCache: sharedCache,
                        communityId: communityId,
                        type: type
                    )
                )
        }
        super.init(
            filter: ModlogEntryFilter(),
            fetcher: MultiFetcher(api: api, pageSize: pageSize, sources: sources, sortType: sortType)
        )
        
        for source in sources {
            source.setParent(parent: self)
        }
    }
    
    public func items(ofType type: ApiModlogActionType) -> [ModlogEntry] {
        modlogSources.first { $0.modlogFetcher.type == type }?.items ?? []
    }
    
    public func refresh(
        communityId: Int? = nil,
        clearBeforeRefresh: Bool = false
    ) async throws {
        sharedCache.communityId = communityId
        modlogSources.forEach { item in
            item.modlogFetcher.communityId = communityId ?? item.modlogFetcher.communityId
        }
        try await refresh(clearBeforeRefresh: clearBeforeRefresh)
    }
    
    override public func refresh(clearBeforeRefresh: Bool) async throws {
        await sharedCache.reset()
        try await super.refresh(clearBeforeRefresh: clearBeforeRefresh)
    }
}
