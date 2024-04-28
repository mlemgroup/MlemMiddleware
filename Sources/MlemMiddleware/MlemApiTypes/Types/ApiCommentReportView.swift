//
//  ApiCommentReportView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CommentReportView.ts
struct ApiCommentReportView: Codable {
    let comment_report: ApiCommentReport
    let comment: ApiComment
    let post: ApiPost
    let community: ApiCommunity
    let creator: ApiPerson
    let comment_creator: ApiPerson
    let counts: ApiCommentAggregates
    let creator_banned_from_community: Bool
    let my_vote: Int?
    let resolver: ApiPerson?
    let creator_is_moderator: Bool? // Exists only in 0.19.4
    let creator_is_admin: Bool? // Exists only in 0.19.4
    let creator_blocked: Bool? // Exists only in 0.19.4
    let subscribed: ApiSubscribedType? // Exists only in 0.19.4
    let saved: Bool? // Exists only in 0.19.4
}
