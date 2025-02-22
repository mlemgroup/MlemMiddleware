//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-22.
//  

import Foundation

extension ApiLocalSite {
    /// Added in 0.20.0
    var backportedCounts: ApiSiteAggregates? {
        guard let users, let posts, let comments, let communities, let usersActiveDay, let usersActiveWeek, let usersActiveMonth, let usersActiveHalfYear else { return nil }
        return .init(
            id: nil,
            siteId: id,
            users: users,
            posts: posts,
            comments: comments,
            communities: communities,
            usersActiveDay: usersActiveDay,
            usersActiveWeek: usersActiveWeek,
            usersActiveMonth: usersActiveMonth,
            usersActiveHalfYear: usersActiveHalfYear
        )
    }
}
