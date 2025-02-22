//
//  ApiPost+ActorIdentifiable.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-19.
//

import Foundation

extension ApiPost: ActorIdentifiable, CacheIdentifiable, Identifiable {
    public var cacheId: Int { id }
    
    /// Added in 0.20.0
    var backportedCounts: ApiPostAggregates? {
        guard let comments, let score, let upvotes, let downvotes, let newestCommentTime else { return nil }
        return .init(
            id: nil,
            postId: id,
            comments: comments,
            score: score,
            upvotes: upvotes,
            downvotes: downvotes,
            published: published,
            newestCommentTimeNecro: nil,
            newestCommentTime: newestCommentTime,
            featuredCommunity: featuredCommunity,
            featuredLocal: featuredLocal,
            hotRank: nil,
            hotRankActive: nil
        )
    }
}

extension ApiPost {
    var linkUrl: URL? { LemmyURL(string: url)?.url }
    // var thumbnailImageUrl: URL? { LemmyURL(string: thumbnail_url)?.url }
    var thumbnailImageUrl: URL? { thumbnailUrl }
    
    var embed: PostEmbed? {
        if embedTitle != nil || embedDescription != nil || embedVideoUrl != nil {
            return .init(
                title: embedTitle,
                description: embedDescription,
                videoUrl: embedVideoUrl
            )
        }
        return nil
    }
}
