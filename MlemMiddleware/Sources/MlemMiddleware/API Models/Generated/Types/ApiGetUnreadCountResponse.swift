//
//  ApiGetUnreadCountResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-21
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetUnreadCountResponse.ts
struct ApiGetUnreadCountResponse: Codable {
    let replies: Int
    let mentions: Int
    let privateMessages: Int
}
