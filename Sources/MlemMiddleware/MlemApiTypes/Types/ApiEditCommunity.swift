//
//  ApiEditCommunity.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// EditCommunity.ts
struct ApiEditCommunity: Codable {
    let community_id: Int
    let title: String?
    let description: String?
    let icon: URL?
    let banner: URL?
    let nsfw: Bool?
    let posting_restricted_to_mods: Bool?
    let discussion_languages: [Int]?
    let only_followers_can_vote: Bool? // Exists only in 0.19.2
    let visibility: ApiCommunityVisibility? // Exists in 0.19.2, 0.19.4 but not in 0.18.0, 0.18.1, 0.18.3, 0.19.0, 0.19.3
}
