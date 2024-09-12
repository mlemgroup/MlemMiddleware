//
//  CommunityPostFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-07.
//

import Foundation

public class CommunityPostFeedLoader: CorePostFeedLoader {
    public var community: any Community
    
    public init(
        pageSize: Int,
        sortType: ApiSortType,
        showReadPosts: Bool,
        filteredKeywords: [String],
        prefetchingConfiguration: PrefetchingConfiguration,
        urlCache: URLCache,
        community: any Community
    ) {
        self.community = community
        super.init(
            pageSize: pageSize,
            sortType: sortType,
            showReadPosts: showReadPosts,
            filteredKeywords: filteredKeywords,
            prefetchingConfiguration: prefetchingConfiguration
        )
    }
    
    override internal func getPosts(page: Int, cursor: String?) async throws -> (posts: [Post2], cursor: String?) {
        return try await community.getPosts(
            sort: sortType,
            page: page,
            cursor: cursor,
            limit: pageSize,
            filter: nil, // TODO
            showHidden: false // TODO
        )
    }
}
