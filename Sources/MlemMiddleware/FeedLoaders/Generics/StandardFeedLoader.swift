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
    let fetcher: any Fetcher<Item>
    var loadingActor: LoadingActor<Item>

    init(filter: MultiFilter<Item>, fetcher: any Fetcher<Item>) {
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
        if clearBeforeRefresh {
            await setItems(.init())
        }
        
        filter.reset()
        await loadingActor.reset()
        
        await setLoading(.loading)
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
        var abort: Bool = false // this is slightly awkward but lets us trigger a loop break from within the switch handlers below
        repeat {
            let loadingResponse = try await loadingActor.load()
            var fetchedItems: [Item] = .init()
            
            switch loadingResponse {
            case let .success(items):
                print("[\(Item.self) FeedLoader] received success (\(items.count))")
                fetchedItems = items
            case let .done(items):
                print("[\(Item.self) FeedLoader] received finished (\(items.count))")
                fetchedItems = items
                await setLoading(.done)
                abort = true
            case .cancelled, .ignored:
                print("[\(Item.self) FeedLoader] load did not complete (\(loadingResponse.description))")
                abort = true
            }
            
            let filteredItems = filter.filter(fetchedItems)
            processFetchedItems(filteredItems)
            newItems.append(contentsOf: filteredItems)
        } while !abort && newItems.count < MiddlewareConstants.infiniteLoadThresholdOffset
        
        return newItems
    }
    
    /// Helper function to perform custom post-fetch processing (e.g., prefetching). Override to implement desired behavior.
    func processFetchedItems(_ items: [Item]) {
        return
    }
}
