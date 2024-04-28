//
//  ApiEditSite.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// EditSite.ts
struct ApiEditSite: Codable {
    let name: String?
    let sidebar: String?
    let description: String?
    let icon: URL?
    let banner: URL?
    let enable_downvotes: Bool?
    let enable_nsfw: Bool?
    let community_creation_admin_only: Bool?
    let require_email_verification: Bool?
    let application_question: String?
    let private_instance: Bool?
    let default_theme: String?
    let default_post_listing_type: ApiListingType?
    let legal_information: String?
    let application_email_admins: Bool?
    let hide_modlog_mod_names: Bool?
    let discussion_languages: [Int]?
    let slur_filter_regex: String?
    let actor_name_max_length: Int?
    let rate_limit_message: Int?
    let rate_limit_message_per_second: Int?
    let rate_limit_post: Int?
    let rate_limit_post_per_second: Int?
    let rate_limit_register: Int?
    let rate_limit_register_per_second: Int?
    let rate_limit_image: Int?
    let rate_limit_image_per_second: Int?
    let rate_limit_comment: Int?
    let rate_limit_comment_per_second: Int?
    let rate_limit_search: Int?
    let rate_limit_search_per_second: Int?
    let federation_enabled: Bool?
    let federation_debug: Bool?
    let federation_worker_count: Int? // Exists only in 0.18.0
    let captcha_enabled: Bool?
    let captcha_difficulty: String?
    let allowed_instances: [String]?
    let blocked_instances: [String]?
    let taglines: [String]?
    let registration_mode: ApiRegistrationMode?
    let reports_email_admins: Bool?
    let content_warning: String? // Exists in 0.19.2, 0.19.4 but not in 0.18.0, 0.18.1, 0.18.3, 0.19.0, 0.19.3
    let auto_expand_images: Bool? // Exists only in 0.19.2
    let default_sort_type: ApiSortType? // Exists only in 0.19.4
    let blocked_urls: [String]? // Exists only in 0.19.4
    let default_post_listing_mode: ApiPostListingMode? // Exists only in 0.19.4
}
