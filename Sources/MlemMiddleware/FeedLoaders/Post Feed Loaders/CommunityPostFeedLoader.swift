//
//  CommunityPostFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-07.
//

import Foundation

class CommunityPostFetchProvider: PostFetchProvider {
    var community: any Community
    
    init(sortType: ApiSortType, pageSize: Int, community: any Community) {
        self.community = community
        
        super.init(api: community.api, sortType: sortType, pageSize: pageSize)
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

public class CommunityPostFeedLoader: CorePostFeedLoader {
    public var community: any Community
    
    public init(
        preheat: Bool,
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
            preheat: preheat,
            api: community.api,
            pageSize: pageSize,
            showReadPosts: showReadPosts,
            filteredKeywords: filteredKeywords,
            prefetchingConfiguration: prefetchingConfiguration,
            fetchProvider: CommunityPostFetchProvider(sortType: sortType, pageSize: pageSize, community: community)
        )
    }
}
