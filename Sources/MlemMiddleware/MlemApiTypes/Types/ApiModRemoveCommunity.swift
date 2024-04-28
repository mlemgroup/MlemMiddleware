//
//  ApiModRemoveCommunity.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ModRemoveCommunity.ts
struct ApiModRemoveCommunity: Codable {
    let id: Int
    let mod_person_id: Int
    let community_id: Int
    let reason: String?
    let removed: Bool
    let expires: String? // Exists <=0.18.3
    let when_: String
}
