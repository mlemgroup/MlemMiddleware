//
//  ApiGetPersonDetailsResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetPersonDetailsResponse.ts
struct ApiGetPersonDetailsResponse: Codable {
    let person_view: ApiPersonView
    let comments: [ApiCommentView]
    let posts: [ApiPostView]
    let moderates: [ApiCommunityModeratorView]
    let site: ApiSite? // Exists >=0.19.2; Optional >=0.19.3
}
