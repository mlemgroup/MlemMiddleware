//
//  ApiMyUserInfo.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// MyUserInfo.ts
struct ApiMyUserInfo: Codable {
    let local_user_view: ApiLocalUserView
    let follows: [ApiCommunityFollowerView]
    let moderates: [ApiCommunityModeratorView]
    let community_blocks: [ApiCommunityBlockView]
    let person_blocks: [ApiPersonBlockView]
    let discussion_languages: [Int]
    let instance_blocks: [ApiInstanceBlockView]? // Exists >=0.19.0
}
