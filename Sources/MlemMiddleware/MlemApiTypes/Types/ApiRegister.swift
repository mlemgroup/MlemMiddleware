//
//  ApiRegister.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// Register.ts
struct ApiRegister: Codable {
    let username: String
    let password: String
    let password_verify: String
    let show_nsfw: Bool
    let email: String?
    let captcha_uuid: String?
    let captcha_answer: String?
    let honeypot: String?
    let answer: String?
}
