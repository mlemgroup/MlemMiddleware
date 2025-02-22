//
//  Community1+Codable.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-01.
//  

import Foundation

extension Community1 {
    public struct CodedData: Codable {
        let apiUrl: URL
        let apiMyPersonId: Int?
        let apiCommunity: ApiCommunity
    }
    
    internal var apiCommunity: ApiCommunity {
        .init(
            id: id,
            name: name,
            title: displayName,
            description: description,
            removed: removed,
            published: created,
            updated: updated,
            deleted: deleted,
            nsfw: nsfw,
            actorId: actorId,
            local: apiIsLocal,
            icon: avatar,
            banner: banner,
            hidden: hidden,
            postingRestrictedToMods: onlyModeratorsCanPost,
            instanceId: instanceId,
            followersUrl: nil,
            inboxUrl: nil,
            onlyFollowersCanVote: nil,
            visibility: visibility,
            sidebar: nil,
            subscribers: nil,
            posts: nil,
            comments: nil,
            usersActiveDay: nil,
            usersActiveWeek: nil,
            usersActiveMonth: nil,
            usersActiveHalfYear: nil,
            subscribersLocal: nil,
            reportCount: nil,
            unresolvedReportCount: nil
        )
    }
    
    public func codedData() async throws -> CodedData {
        .init(
            apiUrl: api.baseUrl,
            apiMyPersonId: try await api.myPersonId,
            apiCommunity: apiCommunity
        )
    }
}
