//
//  CorePostFeedLoader.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-01-04.
//

import Foundation
import Nuke
import Observation

@Observable
public class PostFetcher: Fetcher<Post2> {
    var sortType: ApiSortType
    
    init(api: ApiClient, sortType: ApiSortType, pageSize: Int) {
        self.sortType = sortType
        
        super.init(api: api, pageSize: pageSize)
    }
    
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        let result = try await getPosts(page: page, cursor: nil)

        return .init(
            items: result.posts,
            prevCursor: nil,
            nextCursor: result.cursor
        )
    }
    
    override func fetchCursor(_ cursor: String) async throws -> FetchResponse {
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
    let loopsIntegration: Bool
    
    // store reference to the filter used by the LoadingActor so we can modify its filterContext from changeApi
    internal var filter: PostFilter
    
    // force unwrap because this should ALWAYS be a PostFetcher
    private var postFetcher: PostFetcher { fetcher as! PostFetcher }
    
    public var sortType: ApiSortType { postFetcher.sortType }
    
    internal init(
        api: ApiClient,
        pageSize: Int,
        showReadPosts: Bool,
        filterContext: FilterContext,
        loopsIntegration: Bool,
        prefetchingConfiguration: PrefetchingConfiguration,
        fetcher: PostFetcher
    ) {
        self.prefetchingConfiguration = prefetchingConfiguration
        self.loopsIntegration = loopsIntegration

        let filter: PostFilter = .init(showRead: showReadPosts, context: filterContext)
        self.filter = filter
        
        super.init(
            filter: filter,
            fetcher: fetcher
        )
    }
    
    // MARK: StandardFeedLoader Loading Methods
  
    override func processNewItems(_ items: [Post2]) {
        Task {
            await preloadImages(items)
        }
    }
    
    // MARK: Custom Behavior

    override public func changeApi(to newApi: ApiClient, context: FilterContext) async {
        filter.updateContext(to: context)
        await fetcher.changeApi(to: newApi, context: context)
    }
    
    /// Changes the post sort type to the specified value and reloads the feed
    public func changeSortType(to newSortType: ApiSortType, forceRefresh: Bool = false) async throws {
        // don't do anything if sort type not changed
        guard postFetcher.sortType != newSortType || forceRefresh else {
            return
        }
        
        postFetcher.sortType = newSortType
        try await refresh(clearBeforeRefresh: true)
    }
    
    /// Preloads images for the given post
    private func preloadImages(_ posts: [Post2]) async {
        if loopsIntegration {
            let loopsParses = await withTaskGroup(of: Void.self) { taskGroup in
                posts.forEach { post in
                    taskGroup.addTask {
                        await post.parseLoops()
                    }
                }
            }
        }
        
        prefetchingConfiguration.prefetcher.startPrefetching(with: posts.flatMap {
            $0.imageRequests(configuration: prefetchingConfiguration)
        })
    }
    
    public func setPrefetchingConfiguration(_ config: PrefetchingConfiguration) {
        prefetchingConfiguration = config
        Task {
            await preloadImages(items)
        }
    }
}
