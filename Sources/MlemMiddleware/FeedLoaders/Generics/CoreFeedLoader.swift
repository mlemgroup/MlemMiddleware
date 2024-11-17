//
//  CoreFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-22.
//

import Foundation
import Observation

/// Class providing common feed loading functionality for CorePostFeedLoader and ParentFeedLoader
@Observable
public class CoreFeedLoader<Item: FeedLoadable>: FeedLoading {
    private(set) public var items: [Item] = .init()
    internal(set) public var loadingState: LoadingState = .loading
    
    private(set) var thresholds: Thresholds<Item> = .init()
    
    /// If the given item is the loading threshold item, loads more content
    /// This should be called as an .onAppear of every item in a feed that should support infinite scrolling
    public func loadIfThreshold(_ item: Item) throws {
        if loadingState == .idle, thresholds.isThreshold(item) {
            // this is a synchronous function that wraps the loading as a task so that the task is attached to the loader itself, not the view that calls it, and is therefore safe from being cancelled by view redraws
            Task(priority: .userInitiated) {
                try await loadMoreItems()
            }
        }
    }
    
    public func loadMoreItems() async throws {
        preconditionFailure("This method must be overridden by the inheriting class")
    }
    
    public func refresh(clearBeforeRefresh: Bool) async throws {
        preconditionFailure("This method must be implemented by the inheriting class")
    }
    
    /// Updates the loading state
    @MainActor
    func setLoading(_ newState: LoadingState) {
        loadingState = newState
    }
    
    /// Sets the items to a new array
    @MainActor
    func setItems(_ newItems: [Item]) {
        items = newItems
        thresholds.update(with: newItems)
    }
    
    /// Adds the given items to the items array
    /// - Parameter toAdd: items to add
    @MainActor
    func addItems(_ newItems: [Item]) async {
        items.append(contentsOf: newItems)
        thresholds.update(with: newItems)
    }
    
    @MainActor
    func prependItem(_ newItem: Item) async {
        items.prepend(newItem)
    }
    
    // TODO: collapse CoreFeedLoader and StandardFeedLoader
    public func changeApi(to newApi: ApiClient) {
        assertionFailure("Not implemented")
    }
}
