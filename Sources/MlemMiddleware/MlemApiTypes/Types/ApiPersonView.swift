//
//  ApiPersonView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// PersonView.ts
struct ApiPersonView: Codable {
    let person: ApiPerson
    let counts: ApiPersonAggregates
    let is_admin: Bool? // Exists >=0.19.0
}
