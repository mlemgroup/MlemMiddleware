//
//  ApiEditComment.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// EditComment.ts
struct ApiEditComment: Codable {
    let comment_id: Int
    let content: String?
    let language_id: Int?
    let form_id: String? // Exists <=0.18.3
}
