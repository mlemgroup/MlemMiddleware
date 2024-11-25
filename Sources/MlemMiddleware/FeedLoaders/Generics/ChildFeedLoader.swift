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
    
    init(parentTracker: (any FeedLoading)? = nil) {
        self.parent = parentTracker
        self.cursor = 0
    }
}

class ChildFeedLoader: StandardFeedLoader, ChildFeedLoading {
    var streams: [UUID: FeedLoaderStream] = .init()
    var sortType: FeedLoaderSort.SortType
    
    func nextItemSortVal(streamId: UUID, sortType: FeedLoaderSort.SortType) async throws -> FeedLoaderSort? {
        assert(sortType == self.sortType, "Conflicting types for sortType! This will lead to unexpected sortingr behavior.")
        
        guard let stream = streams[streamId], stream.parent != nil else {
            print("[\(Item.self) ChildFeedLoader could not find stream or parent for \(streamId)")
            return nil
        }
        
        if stream.cursor < items.count {
            return items[stream.cursor].sortVal(sortType: sortType)
        } else {
            if loadingState == .done {
                return nil
            }
            
            try await loadMoreItems()
            
        }
    }
}
