//
//  ApiLocalUser.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// LocalUser.ts
struct ApiLocalUser: Codable {
    let id: Int
    let person_id: Int
    let email: String?
    let show_nsfw: Bool
    let theme: String
    let default_sort_type: ApiSortType
    let default_listing_type: ApiListingType
    let interface_language: String
    let show_avatars: Bool
    let send_notifications_to_email: Bool
    let validator_time: String? // Exists <=0.18.3
    let show_scores: Bool
    let show_bot_accounts: Bool
    let show_read_posts: Bool
    let show_new_post_notifs: Bool? // Exists <=0.18.3
    let email_verified: Bool
    let accepted_application: Bool
    let totp_2fa_url: String? // Exists <=0.18.3
    let open_links_in_new_tab: Bool? // Exists >=0.18.1
    let blur_nsfw: Bool? // Exists >=0.19.0
    let auto_expand: Bool? // Exists >=0.19.0
    let infinite_scroll_enabled: Bool? // Exists >=0.19.0
    let admin: Bool? // Exists >=0.19.0
    let post_listing_mode: ApiPostListingMode? // Exists >=0.19.0
    let totp_2fa_enabled: Bool? // Exists >=0.19.0
    let enable_keyboard_navigation: Bool? // Exists >=0.19.0
    let enable_animated_images: Bool? // Exists >=0.19.0
    let collapse_bot_comments: Bool? // Exists >=0.19.0
}
