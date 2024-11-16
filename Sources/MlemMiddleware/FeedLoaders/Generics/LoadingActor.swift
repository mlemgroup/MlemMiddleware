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

public class Fetcher<Item: FeedLoadable> {
    var pageSize: Int
    var page: Int
    private var cursor: String?
    
    init (pageSize: Int, page: Int = 0) {
        self.pageSize = pageSize
        self.page = page
    }
    
    /// Helper struct bundling the response from a fetchPage or fetchCursor call
    struct FetchResponse {
        /// Items returned
        public let items: [Item]
        
        /// Cursor used to fetch this response, if applicable
        public let prevCursor: String?
        
        /// New cursor, if applicable
        public let nextCursor: String?
    }
    
    /// Fetches the next page of items
    func fetch() async throws -> LoadingResponse<Item> {
        do {
            if let cursor, page > 0 {
                print("[\(Item.self) Fetcher] loading cursor \(cursor)")
                let response = try await fetchCursor(cursor)
                
                // if same cursor returned, loading is finished
                if response.nextCursor == self.cursor {
                    return .done(response.items)
                }
                
                self.cursor = response.nextCursor
                return .success(response.items)
            } else {
                page += 1
                print("[\(Item.self) Fetcher] loading page \(page)")
                let response = try await fetchPage(page)
                
                // if nothing returned, loading is finished
                if response.items.count < pageSize {
                    print("[\(Item.self) Fetcher] received undersized page (\(response.items.count)/\(pageSize))")
                    return .done(response.items)
                }
                self.cursor = response.nextCursor
                return .success(response.items)
            }
        } catch is CancellationError {
            return .cancelled
        }
    }
    
    /// Fetches the given page of items.
    /// - Parameters:
    ///   - page: page number to fetch
    /// - Returns: tuple of the requested page of items, the cursor returned by the API call (if present), and the number of items that were filtered out.
    func fetchPage(_ page: Int) async throws -> FetchResponse {
        preconditionFailure("This method must be implemented by the inheriting class")
    }
    
    /// Fetches items from the given cursor.
    /// - Parameters:
    ///   - cursor: cursor to fetch
    /// - Returns: tuple of the requested page of items, the cursor returned by the API call (if present), and the number of items that were filtered out.
    func fetchCursor(_ cursor: String) async throws -> FetchResponse {
        preconditionFailure("This method must be implemented by the inheriting class")
    }
    
    /// Resets the fetcher's page and cursor tracking. This method should only be overridden to handle abnormal pagination behavior (e.g., PersonContentFetcher); it should NOT change loading parameters such as query or sort.
    func reset() {
        page = 0
        cursor = nil
    }
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
