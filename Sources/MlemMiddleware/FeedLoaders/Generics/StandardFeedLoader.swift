//
//  StandardFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-10-15.
//

import Foundation
import Semaphore
import Observation

@Observable
public class StandardFeedLoader<Item: FeedLoadable>: FeedLoading {
    private(set) public var items: [Item] = .init()
    internal(set) public var loadingState: LoadingState = .loading
    private(set) var thresholds: Thresholds<Item> = .init()
    
    let fetcher: Fetcher<Item>
    var loadingActor: LoadingActor<Item>

    init(filter: MultiFilter<Item>, fetcher: Fetcher<Item>) {
        self.fetcher = fetcher
        self.loadingActor = .init(fetcher: fetcher, filter: filter)
    }

    // MARK: - State Modification Methods
    
    /// Updates the loading state
    @MainActor
    func setLoading(_ newState: LoadingState) {
        loadingState = newState
        print("[\(Item.self) FeedLoader] set loading state to \(newState)")
    }
    
    /// Sets the items to a new array
    @MainActor
    func setItems(_ newItems: [Item]) {
        processNewItems(newItems)
        items = newItems
        thresholds.update(with: newItems)
    }
    
    /// Adds the given items to the items array
    /// - Parameter toAdd: items to add
    @MainActor
    func addItems(_ newItems: [Item]) async {
        processNewItems(newItems)
        items.append(contentsOf: newItems)
        thresholds.update(with: newItems)
    }
    
    @MainActor
    func prependItem(_ newItem: Item) async {
        items.prepend(newItem)
    }
    
    // MARK: - External methods

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
    
    /// Loads the next page of items. Returns when more items have been added to the items array or loading is complete, even
    /// if called while another load is underway
    public func loadMoreItems() async throws {
        try await loadMoreItems(overwriteExistingItems: false)
    }
    
    /// Internal loadMoreItems() that allows overwriting existing items, used to back refresh
    internal func loadMoreItems(overwriteExistingItems: Bool) async throws {
        await setLoading(.loading)
  
        try await loadingActor.load { response in
            var newItems: [Item]?
            
            switch response {
            case let .success(items):
                newItems = items
                await self.setLoading(items.count > 0 ? .idle : .done)
            case let .done(items):
                newItems = items
                await self.setLoading(.done)
            case .ignored, .cancelled:
                print("[\(Item.self) FeedLoader] load did not complete (\(response.description))")
                await self.setLoading(.idle)
            }
            
            if let newItems {
                if overwriteExistingItems {
                    await self.setItems(newItems)
                } else {
                    await self.addItems(newItems)
                }
            }
            
            print("[\(Item.self) FeedLoader] loadMoreItems complete")
        }
    }
    
    public func refresh(clearBeforeRefresh: Bool) async throws {
        await setLoading(.loading)
        
        if clearBeforeRefresh {
            await setItems(.init())
        }
        
        await loadingActor.reset()
    
        try await loadMoreItems(overwriteExistingItems: true)
    }

    public func clear() async {
        await loadingActor.reset()
        await setItems(.init())
        await setLoading(.idle)
    }
    
    /// Helper function to perform custom post-fetch processing (e.g., prefetching). Override to implement desired behavior.
    func processNewItems(_ items: [Item]) {
        return
    }
    
    public func changeApi(to newApi: ApiClient) async {
        await fetcher.changeApi(to: newApi)
    }
}
