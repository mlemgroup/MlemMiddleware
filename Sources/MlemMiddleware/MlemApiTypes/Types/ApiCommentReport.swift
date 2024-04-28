//
//  ApiCommentReport.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CommentReport.ts
struct ApiCommentReport: Codable {
    let id: Int
    let creator_id: Int
    let comment_id: Int
    let original_comment_text: String
    let reason: String
    let resolved: Bool
    let resolver_id: Int?
    let published: Date
    let updated: Date?
}
