//
//  CorePostFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-01-04.
//

import Foundation
import Nuke
import Observation

class PostFetchProvider: FetchProviding {
    typealias Item = Post2
    
    let api: ApiClient
    
    init(api: ApiClient) {
        self.api = api
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
    public var sortType: ApiSortType
    public private(set) var prefetchingConfiguration: PrefetchingConfiguration
    
//    public init(
//        api: ApiClient,
//        pageSize: Int,
//        sortType: ApiSortType,
//        showReadPosts: Bool,
//        filteredKeywords: [String],
//        prefetchingConfiguration: PrefetchingConfiguration
//    ) {
//        assertionFailure("This initializer should not be called")
//        
//        self.sortType = sortType
//        self.prefetchingConfiguration = prefetchingConfiguration
//        
//        let filter = PostFilter(showRead: showReadPosts)
//        
//        super.init(
//            pageSize: pageSize,
//            filter: filter,
//            loadingActor: .init(fetchProvider: PostFetchProvider(api: api, filter: filter, prefetchingConfiguration: prefetchingConfiguration))
//        )
//    }
    
    internal init(
        api: ApiClient,
        pageSize: Int,
        sortType: ApiSortType,
        showReadPosts: Bool,
        filteredKeywords: [String],
        prefetchingConfiguration: PrefetchingConfiguration,
        fetchProvider: (PostFilter, PrefetchingConfiguration, ApiListingType, ApiSortType, Int) -> PostFetchProvider
    ) {
        self.sortType = sortType
        self.prefetchingConfiguration = prefetchingConfiguration
        
        let filter = PostFilter(showRead: showReadPosts)
        
        super.init(
            pageSize: pageSize,
            filter: filter,
            loadingActor: .init(fetchProvider: fetchProvider)
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
        guard sortType != newSortType || forceRefresh else {
            return
        }
        
        sortType = newSortType
        try await refresh(clearBeforeRefresh: true)
    }
    
    /// Adds a filter to the tracker, removing all current posts that do not pass the filter and filtering out all future posts that do not pass the filter.
    /// Use in situations where filtering is handled client-side (e.g., filtering read posts or keywords)
    /// - Parameter newFilter: NewPostFilterReason describing the filter to apply
    public func addFilter(_ newFilter: PostFilterType) async throws {
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
