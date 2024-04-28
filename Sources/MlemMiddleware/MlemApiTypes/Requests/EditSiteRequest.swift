//
//  EditSiteRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct EditSiteRequest: ApiPutRequest {
    typealias Body = ApiEditSite
    typealias Response = ApiSiteResponse

    let path = "site"
    let body: Body?

    init(
      name: String?,
      sidebar: String?,
      description: String?,
      icon: URL?,
      banner: URL?,
      enableDownvotes: Bool?,
      enableNsfw: Bool?,
      communityCreationAdminOnly: Bool?,
      requireEmailVerification: Bool?,
      applicationQuestion: String?,
      privateInstance: Bool?,
      defaultTheme: String?,
      defaultPostListingType: ApiListingType?,
      legalInformation: String?,
      applicationEmailAdmins: Bool?,
      hideModlogModNames: Bool?,
      discussionLanguages: [Int]?,
      slurFilterRegex: String?,
      actorNameMaxLength: Int?,
      rateLimitMessage: Int?,
      rateLimitMessagePerSecond: Int?,
      rateLimitPost: Int?,
      rateLimitPostPerSecond: Int?,
      rateLimitRegister: Int?,
      rateLimitRegisterPerSecond: Int?,
      rateLimitImage: Int?,
      rateLimitImagePerSecond: Int?,
      rateLimitComment: Int?,
      rateLimitCommentPerSecond: Int?,
      rateLimitSearch: Int?,
      rateLimitSearchPerSecond: Int?,
      federationEnabled: Bool?,
      federationDebug: Bool?,
      federationWorkerCount: Int?,
      captchaEnabled: Bool?,
      captchaDifficulty: String?,
      allowedInstances: [String]?,
      blockedInstances: [String]?,
      taglines: [String]?,
      registrationMode: ApiRegistrationMode?,
      reportsEmailAdmins: Bool?,
      contentWarning: String?,
      autoExpandImages: Bool?,
      defaultSortType: ApiSortType?,
      blockedUrls: [String]?,
      defaultPostListingMode: ApiPostListingMode?
    ) {
        self.body = .init(
          name: name,
          sidebar: sidebar,
          description: description,
          icon: icon,
          banner: banner,
          enable_downvotes: enableDownvotes,
          enable_nsfw: enableNsfw,
          community_creation_admin_only: communityCreationAdminOnly,
          require_email_verification: requireEmailVerification,
          application_question: applicationQuestion,
          private_instance: privateInstance,
          default_theme: defaultTheme,
          default_post_listing_type: defaultPostListingType,
          legal_information: legalInformation,
          application_email_admins: applicationEmailAdmins,
          hide_modlog_mod_names: hideModlogModNames,
          discussion_languages: discussionLanguages,
          slur_filter_regex: slurFilterRegex,
          actor_name_max_length: actorNameMaxLength,
          rate_limit_message: rateLimitMessage,
          rate_limit_message_per_second: rateLimitMessagePerSecond,
          rate_limit_post: rateLimitPost,
          rate_limit_post_per_second: rateLimitPostPerSecond,
          rate_limit_register: rateLimitRegister,
          rate_limit_register_per_second: rateLimitRegisterPerSecond,
          rate_limit_image: rateLimitImage,
          rate_limit_image_per_second: rateLimitImagePerSecond,
          rate_limit_comment: rateLimitComment,
          rate_limit_comment_per_second: rateLimitCommentPerSecond,
          rate_limit_search: rateLimitSearch,
          rate_limit_search_per_second: rateLimitSearchPerSecond,
          federation_enabled: federationEnabled,
          federation_debug: federationDebug,
          federation_worker_count: federationWorkerCount,
          captcha_enabled: captchaEnabled,
          captcha_difficulty: captchaDifficulty,
          allowed_instances: allowedInstances,
          blocked_instances: blockedInstances,
          taglines: taglines,
          registration_mode: registrationMode,
          reports_email_admins: reportsEmailAdmins,
          content_warning: contentWarning,
          auto_expand_images: autoExpandImages,
          default_sort_type: defaultSortType,
          blocked_urls: blockedUrls,
          default_post_listing_mode: defaultPostListingMode
      )
    }
}
