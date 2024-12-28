//
//  ModlogFeedLoader.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-28.
//  

import Foundation

public class ModlogFeedLoader: StandardFeedLoader<ModlogEntry> {
    
    var modlogFetcher: MultiFetcher<ModlogEntry> { fetcher as! MultiFetcher }
    
    public init(
        api: ApiClient,
        pageSize: Int,
        sortType: FeedLoaderSort.SortType
    ) {
        let sources: [ModlogChildFeedLoader] = ApiModlogActionType.allFilteredCases.map { type in
                .init(
                    api: api,
                    sortType: sortType,
                    fetcher: .init(
                        api: api,
                        pageSize: pageSize,
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
}
