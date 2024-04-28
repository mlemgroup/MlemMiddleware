//
//  ApiLocalUserView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// LocalUserView.ts
struct ApiLocalUserView: Codable {
    let local_user: ApiLocalUser
    let person: ApiPerson
    let counts: ApiPersonAggregates
    let local_user_vote_display_mode: ApiLocalUserVoteDisplayMode? // Exists only in 0.19.4
}
