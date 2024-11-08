//
//  CorePostFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-01-04.
//

import Foundation
import Nuke
import Observation

public class PostFetcher: Fetcher {
    typealias Item = Post2
    
    var api: ApiClient
    var sortType: ApiSortType
    var pageSize: Int
    
    init(api: ApiClient, sortType: ApiSortType, pageSize: Int) {
        self.api = api
        self.sortType = sortType
        self.pageSize = pageSize
    }
    
    func fetchPage(_ page: Int) async throws -> FetchResponse<Post2> {
        let result = try await getPosts(page: page, cursor: nil)

        return .init(
            items: result.posts,
            prevCursor: nil,
            nextCursor: result.cursor
        )
    }
    
    func fetchCursor(_ cursor: String) async throws -> FetchResponse<Post2> {
        let result = try await getPosts(page: 1, cursor: cursor)
        
        return .init(
            items: result.posts,
            prevCursor: cursor,
            nextCursor: result.cursor
        )
    }
    
    internal func getPosts(page: Int, cursor: String?) async throws -> (posts: [Post2], cursor: String?) {
        preconditionFailure("This method must be implemented by the inheriting class")
    }
}

/// Post tracker for use with single feeds. Can easily be extended to load any pure post feed by creating an inheriting class that overrides getPosts().
@Observable
public class CorePostFeedLoader: StandardFeedLoader<Post2> {
    public private(set) var prefetchingConfiguration: PrefetchingConfiguration
    
    // force unwrap because this should ALWAYS be a PostFetcher
    private var postFetcher: PostFetcher { fetcher as! PostFetcher }
    
    public var sortType: ApiSortType { postFetcher.sortType }
    
    internal init(
        api: ApiClient,
        pageSize: Int,
        showReadPosts: Bool,
        filteredKeywords: [String],
        prefetchingConfiguration: PrefetchingConfiguration,
        fetcher: PostFetcher
    ) {
        self.prefetchingConfiguration = prefetchingConfiguration
        
        let filter = PostFilter(showRead: showReadPosts)
        
        super.init(
            filter: filter,
            fetcher: fetcher
        )
    }
    
    override public func refresh(clearBeforeRefresh: Bool) async throws {
        try await super.refresh(clearBeforeRefresh: clearBeforeRefresh)
    }
    
    // MARK: StandardFeedLoader Loading Methods
  
    override func processFetchedItems(_ items: [Post2]) {
        preloadImages(items)
    }
    
    // MARK: Custom Behavior
    
    /// Changes the post sort type to the specified value and reloads the feed
    public func changeSortType(to newSortType: ApiSortType, forceRefresh: Bool = false) async throws {
        // don't do anything if sort type not changed
        guard postFetcher.sortType != newSortType || forceRefresh else {
            return
        }
        
        postFetcher.sortType = newSortType
        try await refresh(clearBeforeRefresh: true)
    }
    
    /// Adds a filter to the tracker, removing all current posts that do not pass the filter and filtering out all future posts that do not pass the filter.
    /// Use in situations where filtering is handled client-side (e.g., filtering read posts or keywords)
    /// - Parameter newFilter: NewPostFilterReason describing the filter to apply
    public func addFilter(_ newFilter: PostFilterType) async throws {
        print("DEBUG \(loadingState)")
        if filter.activate(newFilter) {
            await setItems(filter.reset(with: items))
            
            if items.isEmpty {
                try await refresh(clearBeforeRefresh: false)
            }
        }
    }
    
    public func removeFilter(_ filterToRemove: PostFilterType) async throws {
        if filter.deactivate(filterToRemove) {
            try await refresh(clearBeforeRefresh: true)
        }
    }
    
    public func getFilteredCount(for toCount: PostFilterType) -> Int {
        return filter.numFiltered(for: toCount)
    }
    
    /// Preloads images for the given post
    private func preloadImages(_ posts: [Post2]) {
        prefetchingConfiguration.prefetcher.startPrefetching(with: posts.flatMap {
            $0.imageRequests(configuration: prefetchingConfiguration)
        })
    }
    
    public func setPrefetchingConfiguration(_ config: PrefetchingConfiguration) {
        prefetchingConfiguration = config
        preloadImages(items)
    }
}
