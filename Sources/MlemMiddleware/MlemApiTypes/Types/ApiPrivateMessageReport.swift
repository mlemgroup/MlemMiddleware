//
//  ApiPrivateMessageReport.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// PrivateMessageReport.ts
struct ApiPrivateMessageReport: Codable {
    let id: Int
    let creator_id: Int
    let private_message_id: Int
    let original_pm_text: String
    let reason: String
    let resolved: Bool
    let resolver_id: Int?
    let published: Date
    let updated: Date?
}
