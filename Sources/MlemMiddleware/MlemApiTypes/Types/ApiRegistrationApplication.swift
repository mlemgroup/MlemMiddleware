//
//  ApiRegistrationApplication.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// RegistrationApplication.ts
struct ApiRegistrationApplication: Codable {
    let id: Int
    let local_user_id: Int
    let answer: String
    let admin_id: Int?
    let deny_reason: String?
    let published: Date
}
