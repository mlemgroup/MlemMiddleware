//
//  ApiCommunity+Extensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-19.
//

import Foundation

extension ApiCommunity: ActorIdentifiable, CacheIdentifiable, Identifiable {
    public var cacheId: Int { id }
    
    /// Added in 0.20.0
    var backportedCounts: ApiCommunityAggregates? {
        guard let subscribers, let posts, let comments, let usersActiveDay, let usersActiveWeek, let usersActiveMonth, let usersActiveHalfYear, let subscribersLocal else { return nil }
        return .init(
            id: nil,
            communityId: id,
            subscribers: subscribers,
            posts: posts,
            comments: comments,
            published: published,
            usersActiveDay: usersActiveDay,
            usersActiveWeek: usersActiveWeek,
            usersActiveMonth: usersActiveMonth,
            usersActiveHalfYear: usersActiveHalfYear,
            hotRank: nil,
            subscribersLocal: subscribersLocal
        )
    }
}

extension ApiCommunity: Comparable {
    public static func == (lhs: ApiCommunity, rhs: ApiCommunity) -> Bool {
        lhs.actorId == rhs.actorId
    }
    
    public static func < (lhs: ApiCommunity, rhs: ApiCommunity) -> Bool {
        let lhsFullCommunity = lhs.name + lhs.actorId.host
        let rhsFullCommunity = rhs.name + rhs.actorId.host
        return lhsFullCommunity < rhsFullCommunity
    }
}
