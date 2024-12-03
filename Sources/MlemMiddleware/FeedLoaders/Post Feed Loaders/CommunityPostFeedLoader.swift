//
//  CommunityPostFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-07.
//

import Foundation

class CommunityPostFetcher: PostFetcher {
    var community: any Community
    
    init(sortType: ApiSortType, pageSize: Int, filter: MultiFilter<Post2>, community: any Community) {
        self.community = community
        
        super.init(api: community.api, pageSize: pageSize, filter: filter, sortType: sortType)
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
    
    var communityPostFetcher: CommunityPostFetcher { fetcher as! CommunityPostFetcher }
    
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
            api: community.api,
            pageSize: pageSize,
            filteredKeywords: filteredKeywords,
            prefetchingConfiguration: prefetchingConfiguration,
            fetcher: CommunityPostFetcher(sortType: sortType, pageSize: pageSize, filter: .init(), community: community)
        )
    }
    
    override public func changeApi(to newApi: ApiClient) async {
        do {
            let resolvedCommunity = try await newApi.resolve(actorId: community.actorId)
            
            guard let newCommunity = resolvedCommunity as? any Community else {
                assertionFailure("Did not get community back")
                return
            }
            communityPostFetcher.community = newCommunity
        } catch {
            assertionFailure("Couldn't change API")
        }
    }
}
