//
//  SaveUserSettingsRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct SaveUserSettingsRequest: ApiPutRequest {
    typealias Body = ApiSaveUserSettings
    typealias Response = ApiSuccessResponse

    let path = "user/save_user_settings"
    let body: Body?

    init(
      showNsfw: Bool?,
      showScores: Bool?,
      theme: String?,
      defaultSortType: ApiSortType?,
      defaultListingType: ApiListingType?,
      interfaceLanguage: String?,
      avatar: URL?,
      banner: URL?,
      displayName: String?,
      email: String?,
      bio: String?,
      matrixUserId: String?,
      showAvatars: Bool?,
      sendNotificationsToEmail: Bool?,
      botAccount: Bool?,
      showBotAccounts: Bool?,
      showReadPosts: Bool?,
      showNewPostNotifs: Bool?,
      discussionLanguages: [Int]?,
      generateTotp2fa: Bool?,
      openLinksInNewTab: Bool?,
      blurNsfw: Bool?,
      autoExpand: Bool?,
      infiniteScrollEnabled: Bool?,
      postListingMode: ApiPostListingMode?,
      enableKeyboardNavigation: Bool?,
      enableAnimatedImages: Bool?,
      collapseBotComments: Bool?,
      showUpvotes: Bool?,
      showDownvotes: Bool?,
      showUpvotePercentage: Bool?
    ) {
        self.body = .init(
          show_nsfw: showNsfw,
          show_scores: showScores,
          theme: theme,
          default_sort_type: defaultSortType,
          default_listing_type: defaultListingType,
          interface_language: interfaceLanguage,
          avatar: avatar,
          banner: banner,
          display_name: displayName,
          email: email,
          bio: bio,
          matrix_user_id: matrixUserId,
          show_avatars: showAvatars,
          send_notifications_to_email: sendNotificationsToEmail,
          bot_account: botAccount,
          show_bot_accounts: showBotAccounts,
          show_read_posts: showReadPosts,
          show_new_post_notifs: showNewPostNotifs,
          discussion_languages: discussionLanguages,
          generate_totp_2fa: generateTotp2fa,
          open_links_in_new_tab: openLinksInNewTab,
          blur_nsfw: blurNsfw,
          auto_expand: autoExpand,
          infinite_scroll_enabled: infiniteScrollEnabled,
          post_listing_mode: postListingMode,
          enable_keyboard_navigation: enableKeyboardNavigation,
          enable_animated_images: enableAnimatedImages,
          collapse_bot_comments: collapseBotComments,
          show_upvotes: showUpvotes,
          show_downvotes: showDownvotes,
          show_upvote_percentage: showUpvotePercentage
      )
    }
}
