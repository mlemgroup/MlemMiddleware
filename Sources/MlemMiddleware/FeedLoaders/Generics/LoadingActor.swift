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
    
    /// Number of items filtered out
    public let numFiltered: Int
    
    /// True if the response has content, false otherwise. It is possible for a filter to remove all fetched items; this avoids that triggering an erroneous end of feed.
    public var hasContent: Bool {
        (prevCursor == nil || nextCursor != prevCursor) && // if cursor used to fetch, ensure same cursor not returned
        items.count + numFiltered > 0 // total sum of fetched items non-zero
    }
}

enum LoadingResponse<Item: FeedLoadable> {
    enum FailureReason: String {
        case error, cancelled, ignored
    }
    
    case success(FetchResponse<Item>)
    case failure(FailureReason)
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
        page = 0
        cursor = nil
    }
    
    /// Resets this LoadingActor, then loads the first page of items
    func refresh() async -> LoadingResponse<Item> {
        reset()
        return await load()
    }
    
    /// Loads the next page of items.
    /// - Returns: on success, .success with FetchResponse containing loaded items; if another load is underway, .ignored; if the load is cancelled, .cancelled
    func load() async -> LoadingResponse<Item> {
        guard loadingTask == nil else {
            print("DEBUG [\(Item.self) loader] ignoring request, load underway")
            return .failure(.ignored)
        }
        
        loadingTask = Task<LoadingResponse<Item>, Error> {
            do {
                if let cursor, page > 0 {
                    return .success(try await fetchProvider.fetchCursor(cursor))
                } else {
                    page += 1
                    return .success(try await fetchProvider.fetchPage(page))
                }
            } catch is CancellationError {
                return .failure(.cancelled)
            }
        }
        
        do {
            guard let loadingTask else {
                assertionFailure("loadingTask is nil!")
                return .failure(.error)
            }
            return try await loadingTask.result.get()
        } catch {
            print(error)
            return .failure(.error)
        }
    }
}
