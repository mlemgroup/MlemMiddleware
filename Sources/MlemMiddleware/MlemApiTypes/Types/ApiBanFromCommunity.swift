//
//  ApiBanFromCommunity.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// BanFromCommunity.ts
struct ApiBanFromCommunity: Codable {
    let community_id: Int
    let person_id: Int
    let ban: Bool
    let remove_data: Bool?
    let reason: String?
    let expires: Int?
}
