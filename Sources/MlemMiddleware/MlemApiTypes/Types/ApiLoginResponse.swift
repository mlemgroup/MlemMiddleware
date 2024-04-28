//
//  ApiLoginResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// LoginResponse.ts
struct ApiLoginResponse: Codable {
    let jwt: String?
    let registration_created: Bool
    let verify_email_sent: Bool
}
