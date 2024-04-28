//
//  ApiSiteAggregates.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// SiteAggregates.ts
struct ApiSiteAggregates: Codable {
    let id: Int? // Exists <=0.18.3
    let site_id: Int
    let users: Int
    let posts: Int
    let comments: Int
    let communities: Int
    let users_active_day: Int
    let users_active_week: Int
    let users_active_month: Int
    let users_active_half_year: Int
}
