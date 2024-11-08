//
//  LoadingActor.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-10-27.
//

import Foundation

/// Helper struct bundling the response from a fetchPage or fetchCursor call
public struct FetchResponse<Item: FeedLoadable> {
    /// Items returned
    public let items: [Item]
    
    /// Cursor used to fetch this response, if applicable
    public let prevCursor: String?
    
    /// New cursor, if applicable
    public let nextCursor: String?
}

enum LoadingError: Error {
    case noTask
}

enum LoadingResponse<Item: FeedLoadable> {
    /// Indicates a successful load with more items available to fetch
    case success([Item])
    
    /// Indicates a successful load with no more items available to fetch
    case done([Item])
    
    /// Indicates the load was ignored due to an existing ongoing load
    case ignored
    
    /// Indicates the load was cancelled
    case cancelled
    
    var description: String {
        switch self {
        case let .success(items): "success (\(items.count))"
        case let .done(items): "done (\(items.count))"
        case .ignored: "ignored"
        case .cancelled: "cancelled"
        }
    }
}

protocol FetchProviding<Item> {
    associatedtype Item: FeedLoadable
    
    /// Fetches the given page of items. This method must be supplied by the parent FeedLoader because different items are loaded differently. The parent FeedLoader is responsible for handling fetch parameters (e.g., page size, unread only) and performing filtering
    /// - Parameters:
    ///   - page: page number to fetch
    /// - Returns: tuple of the requested page of items, the cursor returned by the API call (if present), and the number of items that were filtered out.
    func fetchPage(_ page: Int) async throws -> FetchResponse<Item>
    
    /// Fetches items from the given cursor. This method must be supplied by the parent FeedLoader because different items are loaded differently. The parent FeedLoader is responsible for handling fetch parameters (e.g., page size, unread only) and performing filtering
    /// - Parameters:
    ///   - cursor: cursor to fetch
    /// - Returns: tuple of the requested page of items, the cursor returned by the API call (if present), and the number of items that were filtered out.
    func fetchCursor(_ cursor: String) async throws -> FetchResponse<Item>
}

actor LoadingActor<Item: FeedLoadable> {
    private var page: Int = 0
    private var cursor: String?
    private var loadingTask: Task<LoadingResponse<Item>, Error>?
    private var done: Bool = false
  
    private var fetchProvider: any FetchProviding<Item>
    
    public init(fetchProvider: any FetchProviding<Item>) {
        self.fetchProvider = fetchProvider
    }
    
    /// Resets the loading actor and updates the fetching behavior to use the provided callbacks
    func updateFetching(fetchProvider: any FetchProviding<Item>) {
        reset()
        self.fetchProvider = fetchProvider
    }
    
    /// Cancels any ongoing loading and resets the page/cursor to 0
    func reset() {
        loadingTask?.cancel()
        loadingTask = nil
        done = false
        page = 0
        cursor = nil
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
            do {
                if let cursor, page > 0 {
                    print("[\(Item.self) LoadingActor] loading cursor \(cursor)")
                    let response = try await fetchProvider.fetchCursor(cursor)
                    
                    // if same cursor returned, loading is finished
                    if response.nextCursor == self.cursor {
                        self.done = true
                        return .done(response.items)
                    }
                    
                    self.cursor = response.nextCursor
                    return .success(response.items)
                } else {
                    page += 1
                    print("[\(Item.self) LoadingActor] loading page \(page)")
                    let response = try await fetchProvider.fetchPage(page)
                    
                    // if nothing returned, loading is finished
                    if response.items.isEmpty {
                        done = true
                        return .done(.init())
                    }
                    self.cursor = response.nextCursor
                    return .success(response.items)
                }
            } catch is CancellationError {
                return .cancelled
            }
        }
        
        do {
            guard let loadingTask else {
                assertionFailure("loadingTask is nil!")
                throw LoadingError.noTask
            }
            return try await loadingTask.result.get()
        } catch ApiClientError.cancelled {
            return .cancelled
        }
    }
}
