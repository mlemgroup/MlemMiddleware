//
//  ApiCommunityView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CommunityView.ts
struct ApiCommunityView: Codable {
    let community: ApiCommunity
    let subscribed: ApiSubscribedType
    let blocked: Bool
    let counts: ApiCommunityAggregates
    let banned_from_community: Bool? // Exists only in 0.19.4
}
