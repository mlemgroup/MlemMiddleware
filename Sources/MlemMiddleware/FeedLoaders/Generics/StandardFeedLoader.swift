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
    let fetchProvider: FetchProviding<Item>
    var loadingActor: LoadingActor<Item>

    init(pageSize: Int, filter: MultiFilter<Item>, loadingActor: LoadingActor<Item>) {
        self.filter = filter
        self.loadingActor = loadingActor
        super.init(pageSize: pageSize)
    }

    // MARK: - External methods
    
    override public func loadMoreItems() async throws {
        await setLoading(.loading)
        
        // TODO: retry logic
        // TODO: error handling
        var newItems: [Item] = .init()
        var abort: Bool = false // this is slightly awkward but lets us trigger a loop break from within the switch handlers below
        repeat {
            print("DEBUG repeating load")
            let loadingResponse = await loadingActor.load()
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
            case let .failure(failureReason):
                print("[\(Item.self) FeedLoader] load failed (\(failureReason.rawValue))")
                abort = true
            }
            
            let filteredItems = filter.filter(fetchedItems)
            processFetchedItems(filteredItems)
            newItems.append(contentsOf: filteredItems)
            
        } while !abort && newItems.count < MiddlewareConstants.infiniteLoadThresholdOffset
        
        await addItems(newItems)
        if loadingState != .done {
            await setLoading(.idle)
        }
    }
    
    override public func refresh(clearBeforeRefresh: Bool) async throws {
        if clearBeforeRefresh {
            await setItems(.init())
        }
        
        filter.reset()
        await loadingActor.reset()
        try await loadMoreItems()
    }

    public func clear() async {
        filter.reset()
        await loadingActor.reset()
        await setLoading(.idle)
        await setItems(.init())
    }
    
    /// Helper function to perform custom post-fetch processing (e.g., prefetching). Override to implement desired behavior.
    func processFetchedItems(_ items: [Item]) {
        return
    }
}
