//
//  ApiLocalSiteRateLimit.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// LocalSiteRateLimit.ts
struct ApiLocalSiteRateLimit: Codable {
    let id: Int? // Exists <=0.18.3
    let local_site_id: Int
    let message: Int
    let message_per_second: Int
    let post: Int
    let post_per_second: Int
    let register: Int
    let register_per_second: Int
    let image: Int
    let image_per_second: Int
    let comment: Int
    let comment_per_second: Int
    let search: Int
    let search_per_second: Int
    let published: Date
    let updated: Date?
    let import_user_settings: Int? // Exists >=0.19.0
    let import_user_settings_per_second: Int? // Exists >=0.19.0
}
