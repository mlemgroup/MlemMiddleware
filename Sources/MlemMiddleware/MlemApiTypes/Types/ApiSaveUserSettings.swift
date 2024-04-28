//
//  ApiSaveUserSettings.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// SaveUserSettings.ts
struct ApiSaveUserSettings: Codable {
    let show_nsfw: Bool?
    let show_scores: Bool?
    let theme: String?
    let default_sort_type: ApiSortType?
    let default_listing_type: ApiListingType?
    let interface_language: String?
    let avatar: URL?
    let banner: URL?
    let display_name: String?
    let email: String?
    let bio: String?
    let matrix_user_id: String?
    let show_avatars: Bool?
    let send_notifications_to_email: Bool?
    let bot_account: Bool?
    let show_bot_accounts: Bool?
    let show_read_posts: Bool?
    let show_new_post_notifs: Bool? // Exists <=0.18.3
    let discussion_languages: [Int]?
    let generate_totp_2fa: Bool? // Exists <=0.18.3
    let open_links_in_new_tab: Bool? // Exists >=0.18.1
    let blur_nsfw: Bool? // Exists >=0.19.0
    let auto_expand: Bool? // Exists >=0.19.0
    let infinite_scroll_enabled: Bool? // Exists >=0.19.0
    let post_listing_mode: ApiPostListingMode? // Exists >=0.19.0
    let enable_keyboard_navigation: Bool? // Exists >=0.19.0
    let enable_animated_images: Bool? // Exists >=0.19.0
    let collapse_bot_comments: Bool? // Exists >=0.19.0
    let show_upvotes: Bool? // Exists only in 0.19.4
    let show_downvotes: Bool? // Exists only in 0.19.4
    let show_upvote_percentage: Bool? // Exists only in 0.19.4
}
