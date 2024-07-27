//
//  PersonContentStream.swift
//
//
//  Created by Eric Andrews on 2024-07-21.
//

import Foundation

// This struct is just a convenience wrapper to handle stream state--all loading operations happen at the FeedLoader level to avoid parent/child concurrency control hell
public struct PersonContentStream<Item: PersonContentProviding> {
    var items: [Item]
    var cursor: Int = 0
    var doneLoading: Bool = false
    var thresholds: Thresholds<Item>
    
    init(items: [Item]? = nil) {
        self.thresholds = .init()
        if let items {
            self.items = items
            self.thresholds.update(with: items)
        } else {
            self.items = .init()
        }
    }
    
    var needsMoreItems: Bool { !doneLoading && cursor >= items.count }
    
    mutating func addItems(_ newItems: [Item]) {
        items.append(contentsOf: newItems)
        thresholds.update(with: newItems)
        if newItems.isEmpty {
            doneLoading = true
        }
    }
    
    /// Gets the sort value of the next item in stream for a given sort type without affecting the cursor. Assumes loading has been handled by the FeedLoader.
    /// - Returns: sorting value of the next tracker item corresponding to the given sort type
    /// - Warning: This is NOT a thread-safe function! Only one thread at a time per stream may call this function!
    func nextItemSortVal(sortType: FeedLoaderSort.SortType) async throws -> FeedLoaderSort? {
        guard !doneLoading else {
            return nil
        }
        
        return items[safeIndex: cursor]?.sortVal(sortType: sortType)
    }
    
    /// Gets the next item in the stream and increments the cursor
    /// - Returns: next item in the feed stream
    /// - Warning: This is NOT a thread-safe function! Only one thread at a time per stream may call this function!
    mutating func consumeNextItem() -> PersonContent? {
        guard cursor < items.count else {
            return nil
        }
        
        cursor += 1
        return items[cursor - 1].userContent
    }
}
