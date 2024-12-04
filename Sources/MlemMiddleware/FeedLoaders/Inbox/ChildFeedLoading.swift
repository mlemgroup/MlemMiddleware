//
//  ChildFeedLoading.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-24.
//

//public protocol ChildFeedLoading: FeedLoading {
//    /// Converts the given item to the parent type
//    // func toParent(_ item: Item) -> ParentItem
//    
//    func setParent(parent: any FeedLoading<Item>)
//    
//    /// Gets the sort value of the next item in the stream. If the stream is at its end, loads more items. If there are no more items, returns nil.
//    func nextItemSortVal(sortType: FeedLoaderSort.SortType) async throws -> FeedLoaderSort?
//    
//    /// Returns the nexdt item from the stream and increments the stream cursor by 1
//    func consumeNextItem() -> Item
//    
//    /// Clears the stream, with an optional flag to disable clearing the parent to avoid an infinite loop where parent clears child clears parent etc.
//    func clear(clearParent: Bool) async
//}
