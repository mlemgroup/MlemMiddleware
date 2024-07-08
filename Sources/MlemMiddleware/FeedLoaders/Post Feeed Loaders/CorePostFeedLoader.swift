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
    private(set) var postSortType: ApiSortType
    
    // prefetching
    private let smallAvatarIconSize: Int
    private let largeAvatarIconSize: Int
    private let urlCache: URLCache
    
    public init(
        pageSize: Int,
        sortType: ApiSortType,
        showReadPosts: Bool,
        filteredKeywords: [String],
        smallAvatarSize: CGFloat,
        largeAvatarSize: CGFloat,
        urlCache: URLCache
    ) {
        self.postSortType = sortType
    
        self.smallAvatarIconSize = Int(smallAvatarSize * 2)
        self.largeAvatarIconSize = Int(largeAvatarSize * 2)
        self.urlCache = urlCache
        
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
        preloadImagesHelper(filteredPosts)
        return .init(items: filteredPosts, cursor: result.cursor, numFiltered: result.posts.count - filteredPosts.count)
    }
    
    override public func fetchCursor(cursor: String?) async throws -> FetchResponse<Post2> {
        let result = try await getPosts(page: page, cursor: cursor)
        
        let filteredPosts = filter.filter(result.posts)
        preloadImagesHelper(filteredPosts)
        return .init(items: filteredPosts, cursor: result.cursor, numFiltered: result.posts.count - filteredPosts.count)
    }
    
    internal func getPosts(page: Int, cursor: String?) async throws -> (posts: [Post2], cursor: String?) {
        preconditionFailure("This method must be implemented by the inheriting class")
    }
    
    // MARK: Custom Behavior
    
    /// Changes the post sort type to the specified value and reloads the feed
    public func changeSortType(to newSortType: ApiSortType, forceRefresh: Bool = false) async throws {
        // don't do anything if sort type not changed
        guard postSortType != newSortType || forceRefresh else {
            return
        }
        
        postSortType = newSortType
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
    
    /// Helper method to call preloadImages with this loader's configutration
    private func preloadImagesHelper(_ posts: [Post2]) {
        preloadImages(
            posts,
            smallAvatarIconSize: smallAvatarIconSize,
            largeAvatarIconSize: largeAvatarIconSize,
            urlCache: urlCache
        )
    }
}
