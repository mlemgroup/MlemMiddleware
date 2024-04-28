//
//  ApiListCommentReports.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ListCommentReports.ts
struct ApiListCommentReports: Codable {
    let page: Int?
    let limit: Int?
    let unresolved_only: Bool?
    let community_id: Int?
    let comment_id: Int? // Exists only in 0.19.4
}
