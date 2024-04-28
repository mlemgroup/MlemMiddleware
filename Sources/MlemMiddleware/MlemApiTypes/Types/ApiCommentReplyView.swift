//
//  ApiCommentReplyView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CommentReplyView.ts
struct ApiCommentReplyView: Codable {
    let comment_reply: ApiCommentReply
    let comment: ApiComment
    let creator: ApiPerson
    let post: ApiPost
    let community: ApiCommunity
    let recipient: ApiPerson
    let counts: ApiCommentAggregates
    let creator_banned_from_community: Bool
    let subscribed: ApiSubscribedType
    let saved: Bool
    let creator_blocked: Bool
    let my_vote: Int?
    let creator_is_moderator: Bool? // Exists >=0.19.0
    let creator_is_admin: Bool? // Exists >=0.19.0
    let banned_from_community: Bool? // Exists only in 0.19.4
}
