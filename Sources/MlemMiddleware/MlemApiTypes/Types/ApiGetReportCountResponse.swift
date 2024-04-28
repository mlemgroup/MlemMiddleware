//
//  ApiGetReportCountResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetReportCountResponse.ts
struct ApiGetReportCountResponse: Codable {
    let community_id: Int?
    let comment_reports: Int
    let post_reports: Int
    let private_message_reports: Int?
}
