//
//  MultiFetcher.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-24.
//

class MultiFetcher<Item: FeedLoadable>: Fetcher<Item> {
    var sources: [any ChildFeedLoading]
    var sortType: FeedLoaderSort.SortType
    
    init(api: ApiClient, pageSize: Int, sources: [any ChildFeedLoading], sortType: FeedLoaderSort.SortType) {
        self.sources = sources
        self.sortType = sortType
        
        super.init(api: api, pageSize: pageSize)
    }
    
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
    
    override func reset() async {
        for source in sources {
            await source.clear(clearParent: false)
        }
        
        await super.reset()
    }
    
    /// Computes and returns the highest sorted item from the tops of all sources
    private func computeNextItem() async throws -> Item? {
        var sortVal: FeedLoaderSort?
        var sourceToConsume: (any ChildFeedLoading)?
        
        // find the highest-sorted item from the tops of all sources
        for source in sources {
            (sortVal, sourceToConsume) = try await compareNextItem(lhsVal: sortVal, lhsSource: sourceToConsume, rhsSource: source)
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
    ) async throws -> (FeedLoaderSort?, (any ChildFeedLoading)?) {
        // if no next item on rhs, return lhs (even if null)
        guard let rhsVal = try await rhsSource.nextItemSortVal(sortType: sortType) else {
            return (lhsVal, lhsSource)
        }
        
        // if no lhsVal, rhs next by default
        guard let lhsVal else {
            return (rhsVal, rhsSource)
        }
        
        return lhsVal > rhsVal ? (lhsVal, lhsSource) : (rhsVal, rhsSource)
    }
}