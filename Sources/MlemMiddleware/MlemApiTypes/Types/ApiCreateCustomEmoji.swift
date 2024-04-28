//
//  ApiCreateCustomEmoji.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CreateCustomEmoji.ts
struct ApiCreateCustomEmoji: Codable {
    let category: String
    let shortcode: String
    let image_url: String
    let alt_text: String
    let keywords: [String]
}
