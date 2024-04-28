//
//  ApiCreateComment.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CreateComment.ts
struct ApiCreateComment: Codable {
    let content: String
    let post_id: Int
    let parent_id: Int?
    let language_id: Int?
    let form_id: String? // Exists <=0.18.3
}
