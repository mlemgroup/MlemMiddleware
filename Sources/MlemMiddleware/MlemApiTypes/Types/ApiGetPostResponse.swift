//
//  ApiGetPostResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetPostResponse.ts
struct ApiGetPostResponse: Codable {
    let post_view: ApiPostView
    let community_view: ApiCommunityView
    let moderators: [ApiCommunityModeratorView]
    let cross_posts: [ApiPostView]
}
