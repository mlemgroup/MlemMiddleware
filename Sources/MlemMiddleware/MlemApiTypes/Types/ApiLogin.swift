//
//  ApiLogin.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// Login.ts
struct ApiLogin: Codable {
    let username_or_email: String
    let password: String
    let totp_2fa_token: String?
}
