//
//  ApiEditPost.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// EditPost.ts
struct ApiEditPost: Codable {
    let post_id: Int
    let name: String?
    let url: String?
    let body: String?
    let nsfw: Bool?
    let language_id: Int?
    let alt_text: String? // Exists only in 0.19.4
    let custom_thumbnail: String? // Exists only in 0.19.4
}
