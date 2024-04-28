//
//  ApiModRemovePost.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ModRemovePost.ts
struct ApiModRemovePost: Codable {
    let id: Int
    let mod_person_id: Int
    let post_id: Int
    let reason: String?
    let removed: Bool
    let when_: String
}
