//
//  ApiModLockPost.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ModLockPost.ts
struct ApiModLockPost: Codable {
    let id: Int
    let mod_person_id: Int
    let post_id: Int
    let locked: Bool
    let when_: String
}
