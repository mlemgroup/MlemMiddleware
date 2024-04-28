//
//  ApiGetComments.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetComments.ts
struct ApiGetComments: Codable {
    let type_: ApiListingType?
    let sort: ApiCommentSortType?
    let max_depth: Int?
    let page: Int?
    let limit: Int?
    let community_id: Int?
    let community_name: String?
    let post_id: Int?
    let parent_id: Int?
    let saved_only: Bool?
    let liked_only: Bool? // Exists >=0.19.0
    let disliked_only: Bool? // Exists >=0.19.0
}
