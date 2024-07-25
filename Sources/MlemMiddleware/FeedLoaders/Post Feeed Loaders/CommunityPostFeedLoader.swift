//
//  CommunityPostFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-07.
//

import Foundation

public class CommunityPostFeedLoader: CorePostFeedLoader {
    private var community: any Community
    
    public init(
        pageSize: Int,
        sortType: ApiSortType,
        showReadPosts: Bool,
        filteredKeywords: [String],
        smallAvatarSize: CGFloat,
        largeAvatarSize: CGFloat,
        urlCache: URLCache,
        community: any Community
    ) {
        self.community = community
        super.init(
            pageSize: pageSize,
            sortType: sortType,
            showReadPosts: showReadPosts,
            filteredKeywords: filteredKeywords,
            smallAvatarSize: smallAvatarSize,
            largeAvatarSize: largeAvatarSize
        )
    }
    
    override internal func getPosts(page: Int, cursor: String?) async throws -> (posts: [Post2], cursor: String?) {
        return try await community.getPosts(
            sort: postSortType,
            page: page,
            cursor: cursor,
            limit: pageSize,
            filter: nil, // TODO
            showHidden: false // TODO
        )
    }
}
