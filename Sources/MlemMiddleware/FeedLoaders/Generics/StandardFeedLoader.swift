//
//  StandardFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-10-15.
//

import Foundation
import Semaphore
import Observation

/// Enumeration of loading actions
enum LoadAction {
    /// Clears the tracker
    case clear
    
    /// Refreshes the tracker, loading the first page of new items. If associated bool is true, clears the tracker before loading new items.
    case refresh(Bool)
    
    /// Load the requested page
    case loadPage(Int)
    
    /// Load the requested cursor
    case loadCursor(String)
}

@Observable
public class StandardFeedLoader<Item: FeedLoadable>: CoreFeedLoader<Item> {
    var filter: MultiFilter<Item>
    /// loading state
    /// number of the most recently loaded page. 0 indicates no content.
    // private(set) var page: Int = 0
    /// cursor of the most recently loaded page. nil indicates no content.
    // private(set) var loadingCursor: String?
    // private let loadingSemaphore: AsyncSemaphore = .init(value: 1)
    
    var loadingActor: LoadingActor<Item>

    init(pageSize: Int, filter: MultiFilter<Item>, loadingActor: LoadingActor<Item>) {
        self.filter = filter
        self.loadingActor = loadingActor
        super.init(pageSize: pageSize)
    }

    // MARK: - External methods
    
    override public func loadMoreItems() async throws {
        await setLoading(.loading)
        let loadingResponse = await loadingActor.load()
        await handleLoadingResponse(loadingResponse)
    }
    
    override public func refresh(clearBeforeRefresh: Bool) async throws {
        if clearBeforeRefresh {
            await setItems(.init())
        }
        
        filter.reset()
        await setLoading(.loading)
        let loadingResponse = try await loadingActor.refresh()
        await handleLoadingResponse(loadingResponse)
    }

    public func clear() async {
        filter.reset()
        await loadingActor.reset()
        await setLoading(.idle)
        await setItems(.init())
    }

    // MARK: - Internal methods
    
    private func handleLoadingResponse(_ loadingResponse: LoadingResponse<Item>) async {
        switch loadingResponse {
        case let .success(fetchResponse):
            print("[\(Item.self) FeedLoader] received \(fetchResponse.items.count) new items")
            
            if fetchResponse.hasContent {
                await addItems(fetchResponse.items)
                await setLoading(.idle)
            } else {
                await setLoading(.done)
            }
        case let .failure(reason):
            print("[\(Item.self) FeedLoader] load failed (\(reason.rawValue))")
            await setLoading(.idle)
        }
    }
}
