//
//  ApiSearch.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// Search.ts
struct ApiSearch: Codable {
    // swiftlint:disable:next identifier_name
    let q: String
    let community_id: Int?
    let community_name: String?
    let creator_id: Int?
    let type_: ApiSearchType?
    let sort: ApiSortType?
    let listing_type: ApiListingType?
    let page: Int?
    let limit: Int?
}
