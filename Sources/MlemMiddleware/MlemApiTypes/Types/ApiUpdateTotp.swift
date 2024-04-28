//
//  ApiUpdateTotp.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// UpdateTotp.ts
// Exists >=0.19.0
struct ApiUpdateTotp: Codable {
    let totp_token: String
    let enabled: Bool
}
