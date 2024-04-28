//
//  ApiPostReportView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// PostReportView.ts
struct ApiPostReportView: Codable {
    let post_report: ApiPostReport
    let post: ApiPost
    let community: ApiCommunity
    let creator: ApiPerson
    let post_creator: ApiPerson
    let creator_banned_from_community: Bool
    let my_vote: Int?
    let counts: ApiPostAggregates
    let resolver: ApiPerson?
    let creator_is_moderator: Bool? // Exists only in 0.19.4
    let creator_is_admin: Bool? // Exists only in 0.19.4
    let subscribed: ApiSubscribedType? // Exists only in 0.19.4
    let saved: Bool? // Exists only in 0.19.4
    let read: Bool? // Exists only in 0.19.4
    let hidden: Bool? // Exists only in 0.19.4
    let creator_blocked: Bool? // Exists only in 0.19.4
    let unread_comments: Int? // Exists only in 0.19.4
}
