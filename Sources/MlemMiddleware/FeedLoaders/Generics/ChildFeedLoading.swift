//
//  ChildFeedLoading.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-24.
//

protocol ChildFeedLoading: FeedLoading {
    associatedtype ParentItem: FeedLoadable
    
    func addParent(parent: any ParentFeedLoading)
    
    func nextItemSortVal(streamId: UUID, sortType: FeedLoaderSort.SortType) async throws -> FeedLoaderSort?
    
    func consumeNextItem(streamId: UUID) -> ParentItem
    
    func clear(clearParents: Bool)
}
