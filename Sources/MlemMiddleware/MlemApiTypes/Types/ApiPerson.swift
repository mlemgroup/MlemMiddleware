//
//  ApiPerson.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// Person.ts
struct ApiPerson: Codable {
    let id: Int
    let name: String
    let display_name: String?
    let avatar: URL?
    let banned: Bool
    let published: Date
    let updated: Date?
    let actor_id: URL
    let bio: String?
    let local: Bool
    let banner: URL?
    let deleted: Bool
    let matrix_user_id: String?
    let admin: Bool? // Exists <=0.18.3
    let bot_account: Bool
    let ban_expires: Date?
    let instance_id: Int
    let inbox_url: String? // Exists between 0.18.1 and 0.18.3
}
