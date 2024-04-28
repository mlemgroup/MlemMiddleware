//
//  ApiComment.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// Comment.ts
struct ApiComment: Codable {
    let id: Int
    let creator_id: Int
    let post_id: Int
    let content: String
    let removed: Bool
    let published: Date
    let updated: Date?
    let deleted: Bool
    let ap_id: URL
    let local: Bool
    let path: String
    let distinguished: Bool
    let language_id: Int
}
