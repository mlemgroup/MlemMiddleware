//
//  ApiGetSiteResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetSiteResponse.ts
struct ApiGetSiteResponse: Codable {
    let site_view: ApiSiteView
    let admins: [ApiPersonView]
    let version: String
    let my_user: ApiMyUserInfo?
    let all_languages: [ApiLanguage]
    let discussion_languages: [Int]
    let taglines: [ApiTagline]
    let custom_emojis: [ApiCustomEmojiView]
    let blocked_urls: [ApiLocalSiteUrlBlocklist]? // Exists only in 0.19.4
}
