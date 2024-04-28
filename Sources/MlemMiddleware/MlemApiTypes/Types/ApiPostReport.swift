//
//  ApiPostReport.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// PostReport.ts
struct ApiPostReport: Codable {
    let id: Int
    let creator_id: Int
    let post_id: Int
    let original_post_name: String
    let original_post_url: String?
    let original_post_body: String?
    let reason: String
    let resolved: Bool
    let resolver_id: Int?
    let published: Date
    let updated: Date?
}
