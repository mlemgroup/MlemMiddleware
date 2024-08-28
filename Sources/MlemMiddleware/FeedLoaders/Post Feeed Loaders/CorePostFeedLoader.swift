//
//  CorePostFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-01-04.
//

import Foundation
import Nuke
import Observation

/// Post tracker for use with single feeds. Can easily be extended to load any pure post feed by creating an inheriting class that overrides getPosts().
@Observable
public class CorePostFeedLoader: StandardFeedLoader<Post2> {
    public var sortType: ApiSortType
    public private(set) var prefetchingConfiguration: PrefetchingConfiguration
    
    public init(
        pageSize: Int,
        sortType: ApiSortType,
        showReadPosts: Bool,
        filteredKeywords: [String],
        prefetchingConfiguration: PrefetchingConfiguration
    ) {
        self.sortType = sortType
        self.prefetchingConfiguration = prefetchingConfiguration
        
        super.init(
            pageSize: pageSize,
            filter: PostFilter(showRead: showReadPosts)
        )
    }
    
    override public func refresh(clearBeforeRefresh: Bool) async throws {
        try await super.refresh(clearBeforeRefresh: clearBeforeRefresh)
    }
    
    // MARK: StandardTracker Loading Methods
    
    override public func fetchPage(page: Int) async throws -> FetchResponse<Post2> {
        let result = try await getPosts(page: page, cursor: nil)

        let filteredPosts = filter.filter(result.posts)
        preloadImages(filteredPosts)
        return .init(
            items: filteredPosts,
            prevCursor: nil,
            nextCursor: result.cursor,
            numFiltered: result.posts.count - filteredPosts.count
        )
    }
    
    override public func fetchCursor(cursor: String?) async throws -> FetchResponse<Post2> {
        let result = try await getPosts(page: page, cursor: cursor)

        let filteredPosts = filter.filter(result.posts)
        preloadImages(filteredPosts)
        return .init(
            items: filteredPosts,
            prevCursor: cursor,
            nextCursor: result.cursor,
            numFiltered: result.posts.count - filteredPosts.count
        )
    }
    
    internal func getPosts(page: Int, cursor: String?) async throws -> (posts: [Post2], cursor: String?) {
        preconditionFailure("This method must be implemented by the inheriting class")
    }
    
    // MARK: Custom Behavior
    
    /// Given an index and a threshold, stages posts before that index to be marked read.
    /// - Parameter index: index to mark read before
    /// - Parameter threshold: how many posts back to mark
    public func stageForMarkRead(before index: Int, offset: Int) {
        // If index less than offset, don't do anything since there are no posts at (index - offset); otherwise stage offset post
        items[safeIndex: index - offset]?.stageMarkRead()
        
        // If we're within offset of end-of-feed, the post needs to stage itself because no later post will stage it
        if index >= items.count - offset {
            items[safeIndex: index]?.stageMarkRead()
        }
    }
    
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
