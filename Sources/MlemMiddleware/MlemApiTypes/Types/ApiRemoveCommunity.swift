//
//  ApiRemoveCommunity.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// RemoveCommunity.ts
struct ApiRemoveCommunity: Codable {
    let community_id: Int
    let removed: Bool
    let reason: String?
    let expires: Int? // Exists <=0.18.3
}
