//
//  ApiListCommunities.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ListCommunities.ts
struct ApiListCommunities: Codable {
    let type_: ApiListingType?
    let sort: ApiSortType?
    let page: Int?
    let limit: Int?
    let show_nsfw: Bool? // Exists >=0.18.1
}
