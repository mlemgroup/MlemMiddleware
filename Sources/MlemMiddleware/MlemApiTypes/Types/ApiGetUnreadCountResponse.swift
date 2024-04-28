//
//  ApiGetUnreadCountResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetUnreadCountResponse.ts
struct ApiGetUnreadCountResponse: Codable {
    let replies: Int
    let mentions: Int
    let private_messages: Int
}
