//
//  ApiPostAggregates.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// PostAggregates.ts
struct ApiPostAggregates: Codable {
    let id: Int? // Exists <=0.18.3
    let post_id: Int
    let comments: Int
    let score: Int
    let upvotes: Int
    let downvotes: Int
    let published: Date
    let newest_comment_time_necro: String? // Exists <=0.18.3
    let newest_comment_time: String? // Exists in 0.18.0, 0.18.1, 0.18.3, 0.19.2, 0.19.3, 0.19.4 but not in 0.19.0
    let featured_community: Bool? // Exists <=0.18.3
    let featured_local: Bool? // Exists <=0.18.3
    let hot_rank: Int? // Exists <=0.18.3
    let hot_rank_active: Int? // Exists <=0.18.3
}
