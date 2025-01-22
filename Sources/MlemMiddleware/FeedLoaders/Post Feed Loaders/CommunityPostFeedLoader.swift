//
//  CommunityPostFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-07.
//

import Foundation

@Observable
class CommunityPostFetcher: PostFetcher {
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
    
    var communityPostFetcher: CommunityPostFetcher { fetcher as! CommunityPostFetcher }
    
    public init(
        pageSize: Int,
        sortType: ApiSortType,
        showReadPosts: Bool,
        filterContext: FilterContext,
        loopsIntegration: Bool,
        prefetchingConfiguration: PrefetchingConfiguration,
        urlCache: URLCache,
        community: any Community
    ) {
        self.community = community
        super.init(
            api: community.api,
            pageSize: pageSize,
            showReadPosts: showReadPosts,
            filterContext: filterContext,
            loopsIntegration: loopsIntegration,
            prefetchingConfiguration: prefetchingConfiguration,
            fetcher: CommunityPostFetcher(sortType: sortType, pageSize: pageSize, community: community)
        )
    }
    
    override public func changeApi(to newApi: ApiClient, context: FilterContext) async {
        do {
            let resolvedCommunity = try await newApi.resolve(actorId: community.actorId)
            
            guard let newCommunity = resolvedCommunity as? any Community else {
                assertionFailure("Did not get community back")
                return
            }
            
            filter.updateContext(to: context)
            communityPostFetcher.community = newCommunity
        } catch {
            assertionFailure("Couldn't change API")
        }
    }
}
