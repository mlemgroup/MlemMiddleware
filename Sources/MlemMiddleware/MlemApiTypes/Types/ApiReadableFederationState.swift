//
//  ApiReadableFederationState.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ReadableFederationState.ts
// Exists >=0.19.0
struct ApiReadableFederationState: Codable {
    let instance_id: Int
    let last_successful_id: Int?
    let last_successful_published_time: String?
    let fail_count: Int
    let last_retry: String?
    let next_retry: String?
}
