//
//  ApiPostView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// PostView.ts
struct ApiPostView: Codable {
    let post: ApiPost
    let creator: ApiPerson
    let community: ApiCommunity
    let creator_banned_from_community: Bool
    let counts: ApiPostAggregates
    let subscribed: ApiSubscribedType
    let saved: Bool
    let read: Bool
    let creator_blocked: Bool
    let my_vote: Int?
    let unread_comments: Int
    let creator_is_moderator: Bool? // Exists >=0.19.0
    let creator_is_admin: Bool? // Exists >=0.19.0
    let banned_from_community: Bool? // Exists only in 0.19.4
    let hidden: Bool? // Exists only in 0.19.4
}
