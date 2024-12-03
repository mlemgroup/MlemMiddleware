//
//  ChildFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-24.
//

/// Helper class bundling a parent feed loader and a position in a ChildFeedLoader's item list
class FeedLoaderStream {
    weak var parent: (any FeedLoading)?
    var cursor: Int
    
    init(parent: (any FeedLoading)? = nil) {
        self.parent = parent
        self.cursor = 0
    }
}

public class ChildFeedLoader<Item: FeedLoadable, ParentItem: FeedLoadable>: StandardFeedLoader<Item>, ChildFeedLoading {
    var stream: FeedLoaderStream?
    var sortType: FeedLoaderSort.SortType
    
    init(filter: MultiFilter<Item>, fetcher: Fetcher<Item>, sortType: FeedLoaderSort.SortType) {
        self.sortType = sortType
        
        super.init(filter: filter, fetcher: fetcher)
    }
    
    public func toParent(_ item: Item) -> ParentItem {
        preconditionFailure("This method must be implemented by the inheriting class")
    }
    
    public func setParent(parent: any FeedLoading) {
        stream = .init(parent: parent)
    }
    
    public func nextItemSortVal(sortType: FeedLoaderSort.SortType) async throws -> FeedLoaderSort? {
        assert(sortType == self.sortType, "Conflicting types for sortType! This will lead to unexpected sorting behavior.")
        
        guard let stream, stream.parent != nil else {
            print("[\(Item.self) ChildFeedLoader] could not find stream or parent")
            return nil
        }
        
        if stream.cursor < items.count {
            return items[stream.cursor].sortVal(sortType: sortType)
        } else {
            if loadingState == .done {
                print("[\(Item.self) ChildFeedLoader] done loading")
                return nil
            }
            
            print("[\(Item.self) ChildFeedLoader] out of items (\(items.count)), loading more")
            try await loadMoreItems()
            
            if stream.cursor >= items.count {
                assert(loadingState == .done, "[\(Item.self) ChildFeedLoader] Invalid loading state \(loadingState)")
                return nil
            }
            
            print("[\(Item.self) ChildFeedLoader] fetched more items (\(items.count))")
            return items[stream.cursor].sortVal(sortType: sortType)
        }
    }
    
    public func consumeNextItem() -> ParentItem {
        guard let stream, stream.parent != nil else {
            assertionFailure("[\(Item.self) ChildFeedLoader] could not find stream or parent")
            return toParent(items.last!)
        }
        
        stream.cursor += 1
        return toParent(items[stream.cursor - 1])
    }
    
    public func clear(clearParent: Bool) async {
        if clearParent {
            await stream?.parent?.clear()
        }
        
        stream?.cursor = 0
        await super.clear()
    }
}
