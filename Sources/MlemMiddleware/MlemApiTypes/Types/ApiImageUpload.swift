//
//  ApiImageUpload.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ImageUpload.ts
// Exists between 0.19.0 and 0.19.3
struct ApiImageUpload: Codable {
    let local_user_id: Int
    let pictrs_alias: String
    let pictrs_delete_token: String
    let published: Date
}
