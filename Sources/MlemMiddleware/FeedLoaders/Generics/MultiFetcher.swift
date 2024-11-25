//
//  MultiFetcher.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-24.
//

class MultiFetcher<Item: FeedLoadable>: Fetcher {
    var sources: [any ChildFeedLoading]
    var sortType: FeedLoaderSort.SortType
    let uuid: UUID
    
    override func fetch() async throws -> LoadingResponse<Item> {
        var newItems: [Item] = .init()
        
        while newItems.count < pageSize {
            if let nextItem = try await computeNextItem() {
                newItems.append(nextItem)
            } else {
                print("[\(Item.self) MultiFetcher] no next item found")
                return .done(newItems)
            }
        }
        
        return .success(newItems)
    }
    
    override func reset() {
        for source in sources {
            source.clear(clearParents: false)
        }
        
        super.reset()
    }
    
    /// Computes and returns the highest sorted item from the tops of all sources
    private func computeNextItem() async throws -> Item? {
        var sortVal: FeedLoaderSort?
        var sourceToConsume: (any ChildFeedLoading)?
        
        // find the highest-sorted item from the tops of all sources
        for source in sources {
            (sortVal, sourceToConsume) = await compareNextTrackerItem(lhsVal: sortVal, lhsSource: sourceToConsume, rhsSource: source)
        }
        
        // ensure the item is of the correct type
        if let sourceToConsume {
            guard let nextItem = sourceToConsume.consumeNextItem() as? Item else {
                assertionFailure("Could not convert item to [\(Item.self)]")
                return nil
            }
            return nextItem
        }
        
        // if no sourceToConsume, loading is finished
        return nil
    }
    
    private func compareNextItem(
        lhsVal: FeedLoaderSort?,
        lhsSource: (any ChildFeedLoading)?,
        rhsSource: any ChildFeedLoading
    ) async throws -> (FeedLoaderSort, (any ChildFeedLoading)?) {
        // if no next item on rhs, return lhs (even if null)
        guard let rhsVal = rhsSource.nextItemSortVal(streamId: uuid, sortType: sortType) else {
            return (lhsVal, lhsSource)
        }
        
        // if no lhsVal, rhs next by default
        guard let lhsVal else {
            return (rhsVal, rhsSource)
        }
        
        return lhsVal > rhsVal ? (lhsVal, lhsSource) : (rhsVal, rhsSource)
    }
}
