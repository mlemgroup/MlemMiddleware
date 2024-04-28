//
//  ApiModBanFromCommunityView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ModBanFromCommunityView.ts
struct ApiModBanFromCommunityView: Codable {
    let mod_ban_from_community: ApiModBanFromCommunity
    let moderator: ApiPerson?
    let community: ApiCommunity
    let banned_person: ApiPerson
}
