//
//  UserContentStream.swift
//
//
//  Created by Eric Andrews on 2024-07-21.
//

import Foundation

// This struct is just a convenience wrapper to handle stream state--all loading operations happen at the FeedLoader level to avoid parent/child concurrency control hell
public struct UserContentStream<Item: FeedLoadable> {
    var items: [Item] = .init()
    var cursor: Int = 0
    var doneLoading: Bool = false
    var thresholds: Thresholds<Item> = .init()
    
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
    mutating func consumeNextItem() -> UserContent? {
        assert(
            cursor < items.count,
            "consumeNextItem called on a stream without a next item (cursor: \(cursor), count: \(items.count))!"
        )

        if cursor < items.count {
            cursor += 1
            return toParent(item: items[cursor - 1])
        }

        return nil
    }
    
    private func toParent(item: Item) -> UserContent? {
        if let post = item as? Post2 {
            return .init(wrappedValue: .post(post))
        }
        if let comment = item as? Comment2 {
            return .init(wrappedValue: .comment(comment))
        }
        // shouldn't ever get here because we know we're getting either Post2 or Comment2
        assertionFailure("Could not convert to parent or comment!")
        return nil
    }
}
