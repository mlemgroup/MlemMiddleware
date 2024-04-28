//
//  ApiSite.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// Site.ts
struct ApiSite: Codable {
    let id: Int
    let name: String
    let sidebar: String?
    let published: Date
    let updated: Date?
    let icon: URL?
    let banner: URL?
    let description: String?
    let actor_id: URL
    let last_refreshed_at: Date
    let inbox_url: String
    let private_key: String? // Exists <=0.19.3
    let public_key: String
    let instance_id: Int
    let content_warning: String? // Exists only in 0.19.4
}
