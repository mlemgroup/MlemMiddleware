//
//  ApiCommentAggregates.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CommentAggregates.ts
struct ApiCommentAggregates: Codable {
    let id: Int? // Exists <=0.18.3
    let comment_id: Int
    let score: Int
    let upvotes: Int
    let downvotes: Int
    let published: Date
    let child_count: Int
    let hot_rank: Int? // Exists <=0.18.3
}
