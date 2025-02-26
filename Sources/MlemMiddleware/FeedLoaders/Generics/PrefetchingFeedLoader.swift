//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-25.
//  

import Foundation
import Observation
import Nuke

@Observable
public class PrefetchingFeedLoader<Item: ImagePrefetchProviding & FeedLoadable>: StandardFeedLoader<Item> {
    public private(set) var prefetchingConfiguration: PrefetchingConfiguration

    internal init(
        filter: MultiFilter<Item>,
        prefetchingConfiguration: PrefetchingConfiguration,
        fetcher: Fetcher<Item>
    ) {
        self.prefetchingConfiguration = prefetchingConfiguration
        
        super.init(
            filter: filter,
            fetcher: fetcher
        )
    }
  
    override func processNewItems(_ items: [Item]) {
        prefetchImages(items)
    }

    private func prefetchImages(_ items: [Item]) {
        Task {
            prefetchingConfiguration.prefetcher.startPrefetching(with: await items.concurrentFlatMap { item -> [ImageRequest] in
                await item.imageRequests(configuration: self.prefetchingConfiguration)
            })
        }
    }
    
    public func setPrefetchingConfiguration(_ config: PrefetchingConfiguration) {
        prefetchingConfiguration = config
        prefetchImages(items)
    }
}
