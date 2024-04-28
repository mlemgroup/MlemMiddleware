//
//  ApiCommunity.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// Community.ts
struct ApiCommunity: Codable {
    let id: Int
    let name: String
    let title: String
    let description: String?
    let removed: Bool
    let published: Date
    let updated: Date?
    let deleted: Bool
    let nsfw: Bool
    let actor_id: URL
    let local: Bool
    let icon: URL?
    let banner: URL?
    let hidden: Bool
    let posting_restricted_to_mods: Bool
    let instance_id: Int
    let followers_url: String? // Exists between 0.18.1 and 0.18.3
    let inbox_url: String? // Exists between 0.18.1 and 0.18.3
    let only_followers_can_vote: Bool? // Exists only in 0.19.2
    let visibility: ApiCommunityVisibility? // Exists in 0.19.2, 0.19.4 but not in 0.18.0, 0.18.1, 0.18.3, 0.19.0, 0.19.3
}
