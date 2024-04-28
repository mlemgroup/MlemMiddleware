//
//  ApiChangePassword.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ChangePassword.ts
struct ApiChangePassword: Codable {
    let new_password: String
    let new_password_verify: String
    let old_password: String
}
