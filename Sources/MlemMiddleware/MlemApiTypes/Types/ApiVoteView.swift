//
//  ApiVoteView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// VoteView.ts
// Exists >=0.19.2
struct ApiVoteView: Codable {
    let creator: ApiPerson
    let score: Int
    let creator_banned_from_community: Bool? // Exists only in 0.19.4
}
