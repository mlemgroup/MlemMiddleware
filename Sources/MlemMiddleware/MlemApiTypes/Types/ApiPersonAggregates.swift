//
//  ApiPersonAggregates.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// PersonAggregates.ts
struct ApiPersonAggregates: Codable {
    let id: Int? // Exists <=0.18.3
    let person_id: Int
    let post_count: Int
    let post_score: Int? // Exists <=0.18.3
    let comment_count: Int
    let comment_score: Int? // Exists <=0.18.3
}
