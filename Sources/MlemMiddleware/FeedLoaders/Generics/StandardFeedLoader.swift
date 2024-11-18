//
//  StandardFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-10-15.
//

import Foundation
import Semaphore
import Observation

@Observable
public class StandardFeedLoader<Item: FeedLoadable>: CoreFeedLoader<Item> {
    var filter: MultiFilter<Item>
    let fetcher: Fetcher<Item>
    var loadingActor: LoadingActor<Item>

    init(filter: MultiFilter<Item>, fetcher: Fetcher<Item>) {
        self.filter = filter
        self.fetcher = fetcher
        self.loadingActor = .init(fetcher: fetcher)
        super.init()
    }

    // MARK: - External methods
    
    override public func loadMoreItems() async throws {
        await setLoading(.loading)
        
        let newItems: [Item] = try await fetchMoreItems()
        await addItems(newItems)
        
        if loadingState != .done && newItems.count > 0 {
            await setLoading(.idle)
        }
    }
    
    override public func refresh(clearBeforeRefresh: Bool) async throws {
        await setLoading(.loading)
        
        if clearBeforeRefresh {
            await setItems(.init())
        }
        
        filter.reset()
        await loadingActor.reset()
    
        let newItems = try await fetchMoreItems()
        await setItems(newItems)
        await setLoading(.idle)
    }

    public func clear() async {
        filter.reset()
        await loadingActor.reset()
        await setItems(.init())
        await setLoading(.idle)
    }
    
    private func fetchMoreItems() async throws -> [Item] {
        var newItems: [Item] = .init()
        fetchLoop: repeat {
            let response = try await loadingActor.load()
            
            switch response {
            case let .success(items):
                print("[\(Item.self) FeedLoader] received success (\(items.count))")
                newItems.append(contentsOf: filter.filter(items))
            case let .done(items):
                print("[\(Item.self) FeedLoader] received finished (\(items.count))")
                newItems.append(contentsOf: filter.filter(items))
                await setLoading(.done)
                break fetchLoop
            case .cancelled, .ignored:
                print("[\(Item.self) FeedLoader] load did not complete (\(response.description))")
                break fetchLoop
            }
        } while newItems.count < MiddlewareConstants.infiniteLoadThresholdOffset
        
        processFetchedItems(newItems)
        return newItems
    }
    
    /// Helper function to perform custom post-fetch processing (e.g., prefetching). Override to implement desired behavior.
    func processFetchedItems(_ items: [Item]) {
        return
    }
    
    override public func changeApi(to newApi: ApiClient) async {
        fetcher.api = newApi
    }
}
