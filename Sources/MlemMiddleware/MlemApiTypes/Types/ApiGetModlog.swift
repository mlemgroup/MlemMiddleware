//
//  ApiGetModlog.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetModlog.ts
struct ApiGetModlog: Codable {
    let mod_person_id: Int?
    let community_id: Int?
    let page: Int?
    let limit: Int?
    let type_: ApiModlogActionType?
    let other_person_id: Int?
    let post_id: Int? // Exists only in 0.19.4
    let comment_id: Int? // Exists only in 0.19.4
}
