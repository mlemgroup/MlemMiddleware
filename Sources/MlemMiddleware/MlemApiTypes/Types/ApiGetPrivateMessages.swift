//
//  ApiGetPrivateMessages.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetPrivateMessages.ts
struct ApiGetPrivateMessages: Codable {
    let unread_only: Bool?
    let page: Int?
    let limit: Int?
    let creator_id: Int? // Exists >=0.19.0
}
