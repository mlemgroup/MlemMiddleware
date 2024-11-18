//
//  LoadingActor.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-10-27.
//

import Foundation

enum LoadingError: Error {
    case noTask
}

actor LoadingActor<Item: FeedLoadable> {
    private var done: Bool = false
    private var loadingTask: Task<LoadingResponse<Item>, Error>?
  
    private var fetcher: Fetcher<Item>
    
    public init(fetcher: Fetcher<Item>) {
        self.fetcher = fetcher
    }
    
    /// Cancels any ongoing loading and resets the page/cursor to 0
    func reset() {
        loadingTask?.cancel()
        loadingTask = nil
        fetcher.reset()
        done = false
    }
    
    /// Loads the next page of items.
    /// - Returns: on success, .success with FetchResponse containing loaded items; if another load is underway, .ignored; if the load is cancelled, .cancelled
    func load() async throws -> LoadingResponse<Item> {
        // if already loading something, ignore the request
        guard loadingTask == nil else {
            print("[\(Item.self) LoadingActor] ignoring request, load underway")
            return .ignored
        }
        
        guard !done else {
            print("[\(Item.self) LoadingActor] ignoring request, finished loading")
            return .done(.init())
        }
        
        // upon completion of load, remove loading task
        defer { loadingTask = nil }
        
        loadingTask = Task<LoadingResponse<Item>, Error> {
            return try await fetcher.fetch()
        }
        
        do {
            guard let loadingTask else {
                assertionFailure("loadingTask is nil!")
                throw LoadingError.noTask
            }
            let result = try await loadingTask.result.get()
            
            if case .done = result {
                self.done = true
            }
            
            return result
        } catch ApiClientError.cancelled {
            return .cancelled
        }
    }
}
