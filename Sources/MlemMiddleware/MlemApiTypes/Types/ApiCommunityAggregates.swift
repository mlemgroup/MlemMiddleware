//
//  ApiCommunityAggregates.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CommunityAggregates.ts
struct ApiCommunityAggregates: Codable {
    let id: Int? // Exists <=0.18.3
    let community_id: Int
    let subscribers: Int
    let posts: Int
    let comments: Int
    let published: Date
    let users_active_day: Int
    let users_active_week: Int
    let users_active_month: Int
    let users_active_half_year: Int
    let hot_rank: Int? // Exists <=0.18.3
    let subscribers_local: Int? // Exists in 0.19.2, 0.19.4 but not in 0.18.0, 0.18.1, 0.18.3, 0.19.0, 0.19.3
}
