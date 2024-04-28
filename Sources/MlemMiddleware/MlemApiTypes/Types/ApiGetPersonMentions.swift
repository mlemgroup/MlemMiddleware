//
//  ApiGetPersonMentions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetPersonMentions.ts
struct ApiGetPersonMentions: Codable {
    let sort: ApiCommentSortType?
    let page: Int?
    let limit: Int?
    let unread_only: Bool?
}
