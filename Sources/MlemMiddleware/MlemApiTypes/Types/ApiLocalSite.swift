//
//  ApiLocalSite.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// LocalSite.ts
struct ApiLocalSite: Codable {
    let id: Int
    let site_id: Int
    let site_setup: Bool
    let enable_downvotes: Bool
    let enable_nsfw: Bool
    let community_creation_admin_only: Bool
    let require_email_verification: Bool
    let application_question: String?
    let private_instance: Bool
    let default_theme: String
    let default_post_listing_type: ApiListingType
    let legal_information: String?
    let hide_modlog_mod_names: Bool
    let application_email_admins: Bool
    let slur_filter_regex: String?
    let actor_name_max_length: Int
    let federation_enabled: Bool
    let federation_worker_count: Int? // Exists only in 0.18.0
    let captcha_enabled: Bool
    let captcha_difficulty: String
    let published: Date
    let updated: Date?
    let registration_mode: ApiRegistrationMode
    let reports_email_admins: Bool
    let federation_signed_fetch: Bool? // Exists >=0.19.0
    let content_warning: String? // Exists only in 0.19.2
    let auto_expand_images: Bool? // Exists only in 0.19.2
    let default_post_listing_mode: ApiPostListingMode? // Exists only in 0.19.4
    let default_sort_type: ApiSortType? // Exists only in 0.19.4
}
