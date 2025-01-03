//
//  Community2+Codable.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-01.
//  

import Foundation

extension Community2 {
    public struct CodedData: Codable {
        let apiUrl: URL
        let apiMyPersonId: Int?
        let apiCommunityView: ApiCommunityView
    }
    
    internal var apiCommunityView: ApiCommunityView {
        .init(
            community: community1.apiCommunity,
            subscribed: subscription.subscribedType,
            blocked: blocked,
            counts: .init(
                id: nil,
                communityId: id,
                subscribers: subscription.actualTotal,
                posts: postCount,
                comments: commentCount,
                published: created,
                usersActiveDay: activeUserCount.day,
                usersActiveWeek: activeUserCount.week,
                usersActiveMonth: activeUserCount.month,
                usersActiveHalfYear: activeUserCount.sixMonths,
                hotRank: nil,
                subscribersLocal: subscription.actualLocal
            ),
            // Our current architecture doesn't allow us to guarantee that the ban status is present here.
            // Once we drop support for 0.19.3 `nil` won't be allowed here anymore; this will become a
            // problem and we'll have to work around it somehow
            bannedFromCommunity: api.myPerson?.isBannedFromCommunity(self)
        )
    }
    
    public func codedData() async throws -> CodedData {
        .init(
            apiUrl: api.baseUrl,
            apiMyPersonId: try await api.myPersonId,
            apiCommunityView: apiCommunityView
        )
    }
}
