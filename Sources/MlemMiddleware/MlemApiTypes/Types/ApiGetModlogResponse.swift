//
//  ApiGetModlogResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// GetModlogResponse.ts
struct ApiGetModlogResponse: Codable {
    let removed_posts: [ApiModRemovePostView]
    let locked_posts: [ApiModLockPostView]
    let featured_posts: [ApiModFeaturePostView]
    let removed_comments: [ApiModRemoveCommentView]
    let removed_communities: [ApiModRemoveCommunityView]
    let banned_from_community: [ApiModBanFromCommunityView]
    let banned: [ApiModBanView]
    let added_to_community: [ApiModAddCommunityView]
    let transferred_to_community: [ApiModTransferCommunityView]
    let added: [ApiModAddView]
    let admin_purged_persons: [ApiAdminPurgePersonView]
    let admin_purged_communities: [ApiAdminPurgeCommunityView]
    let admin_purged_posts: [ApiAdminPurgePostView]
    let admin_purged_comments: [ApiAdminPurgeCommentView]
    let hidden_communities: [ApiModHideCommunityView]
}
