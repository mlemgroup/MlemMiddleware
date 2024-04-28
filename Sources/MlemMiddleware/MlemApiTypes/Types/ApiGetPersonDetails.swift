//
//  ApiGetPersonDetails.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetPersonDetails.ts
struct ApiGetPersonDetails: Codable {
    let person_id: Int?
    let username: String?
    let sort: ApiSortType?
    let page: Int?
    let limit: Int?
    let community_id: Int?
    let saved_only: Bool?
}
