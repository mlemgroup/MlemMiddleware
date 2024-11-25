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
    
    var filter: MultiFilter<Item>
    let fetcher: Fetcher<Item>
    var loadingActor: LoadingActor<Item>

    init(filter: MultiFilter<Item>, fetcher: Fetcher<Item>) {
        self.filter = filter
        self.fetcher = fetcher
        self.loadingActor = .init(fetcher: fetcher)
    }

    // MARK: - State Modification Methods
    
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
    
    public func loadMoreItems() async throws {
        await setLoading(.loading)
        
        let newItems: [Item] = try await fetchMoreItems()
        await addItems(newItems)
        
        if loadingState != .done && newItems.count > 0 {
            await setLoading(.idle)
        }
    }
    
    public func refresh(clearBeforeRefresh: Bool) async throws {
        await setLoading(.loading)
        
        if clearBeforeRefresh {
            await setItems(.init())
        }
        
        filter.reset()
        await loadingActor.reset()
    
        let newItems = try await fetchMoreItems()
        await setItems(newItems)
        await setLoading(.idle)
    }

    public func clear() async {
        filter.reset()
        await loadingActor.reset()
        await setItems(.init())
        await setLoading(.idle)
    }
    
    private func fetchMoreItems() async throws -> [Item] {
        var newItems: [Item] = .init()
        fetchLoop: repeat {
            let response = try await loadingActor.load()
            
            switch response {
            case let .success(items):
                print("[\(Item.self) FeedLoader] received success (\(items.count))")
                newItems.append(contentsOf: filter.filter(items))
            case let .done(items):
                print("[\(Item.self) FeedLoader] received finished (\(items.count))")
                newItems.append(contentsOf: filter.filter(items))
                await setLoading(.done)
                break fetchLoop
            case .cancelled, .ignored:
                print("[\(Item.self) FeedLoader] load did not complete (\(response.description))")
                break fetchLoop
            }
        } while newItems.count < MiddlewareConstants.infiniteLoadThresholdOffset
        
        processFetchedItems(newItems)
        return newItems
    }
    
    /// Helper function to perform custom post-fetch processing (e.g., prefetching). Override to implement desired behavior.
    func processFetchedItems(_ items: [Item]) {
        return
    }
    
    public func changeApi(to newApi: ApiClient) async {
        fetcher.api = newApi
    }
}
