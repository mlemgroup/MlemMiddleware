//
//  StandardFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-10-15.
//

import Foundation
import Semaphore
import Observation

/// Enumeration of loading actions
enum LoadAction {
    /// Clears the tracker
    case clear
    
    /// Refreshes the tracker, loading the first page of new items. If associated bool is true, clears the tracker before loading new items.
    case refresh(Bool)
    
    /// Load the requested page
    case loadPage(Int)
    
    /// Load the requested cursor
    case loadCursor(String)
}

@Observable
public class StandardFeedLoader<Item: FeedLoadable>: CoreFeedLoader<Item> {
    var filter: MultiFilter<Item>
    /// loading state
    /// number of the most recently loaded page. 0 indicates no content.
    // private(set) var page: Int = 0
    /// cursor of the most recently loaded page. nil indicates no content.
    // private(set) var loadingCursor: String?
    // private let loadingSemaphore: AsyncSemaphore = .init(value: 1)
    
    var loadingActor: LoadingActor<Item>

    init(pageSize: Int, filter: MultiFilter<Item>, loadingActor: LoadingActor<Item>) {
        self.filter = filter
        self.loadingActor = loadingActor
        super.init(pageSize: pageSize)
    }

    // MARK: - External methods
    
    override public func loadMoreItems() async throws {
        print("DEBUG called loadMoreItems")
        await setLoading(.loading)
        
        // TODO: retry logic
        // TODO: error handling
        var newItems: [Item] = .init()
        var abort: Bool = false // this is slightly awkward but lets us trigger a loop break from within the switch handlers below
        repeat {
            print("DEBUG repeating load")
            let loadingResponse = await loadingActor.load()
            
            switch loadingResponse {
            case let .success(items):
                print("[\(Item.self) FeedLoader] received success (\(items.count))")
                newItems.append(contentsOf: items)
            case let .done(items):
                print("[\(Item.self) FeedLoader] received finished (\(items.count))")
                newItems.append(contentsOf: items)
                await setLoading(.done)
                abort = true
            case let .failure(failureReason):
                print("[\(Item.self) FeedLoader] load failed (\(failureReason.rawValue))")
                abort = true
            }
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

    // MARK: - Internal methods
    
    /// Helper function to perform filtering operations. By default, does nothing. If filtering is required, override this method and define the necessary filtering logic.
    func filterItems(_ items: [Item]) -> [Item] {
        return items
    }
}
