//
//  ApiGetPosts.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetPosts.ts
struct ApiGetPosts: Codable {
    let type_: ApiListingType?
    let sort: ApiSortType?
    let page: Int?
    let limit: Int?
    let community_id: Int?
    let community_name: String?
    let saved_only: Bool?
    let liked_only: Bool? // Exists >=0.19.0
    let disliked_only: Bool? // Exists >=0.19.0
    let page_cursor: String? // Exists >=0.19.0
    let show_hidden: Bool? // Exists only in 0.19.4
}
