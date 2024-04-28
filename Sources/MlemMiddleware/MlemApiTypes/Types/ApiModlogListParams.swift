//
//  ApiModlogListParams.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ModlogListParams.ts
struct ApiModlogListParams: Codable {
    let community_id: Int?
    let mod_person_id: Int?
    let other_person_id: Int?
    let page: Int?
    let limit: Int?
    let hide_modlog_names: Bool
    let post_id: Int? // Exists only in 0.19.4
    let comment_id: Int? // Exists only in 0.19.4
}
