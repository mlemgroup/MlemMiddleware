//
//  ApiPrivateMessage.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// PrivateMessage.ts
struct ApiPrivateMessage: Codable {
    let id: Int
    let creator_id: Int
    let recipient_id: Int
    let content: String
    let deleted: Bool
    let read: Bool
    let published: Date
    let updated: Date?
    let ap_id: URL
    let local: Bool
}
