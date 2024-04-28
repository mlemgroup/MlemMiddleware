//
//  ApiBanPerson.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// BanPerson.ts
struct ApiBanPerson: Codable {
    let person_id: Int
    let ban: Bool
    let remove_data: Bool?
    let reason: String?
    let expires: Int?
}
