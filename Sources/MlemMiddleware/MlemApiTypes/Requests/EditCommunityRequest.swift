//
//  EditCommunityRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct EditCommunityRequest: ApiPutRequest {
    typealias Body = ApiEditCommunity
    typealias Response = ApiCommunityResponse

    let path = "community"
    let body: Body?

    init(
      communityId: Int,
      title: String?,
      description: String?,
      icon: URL?,
      banner: URL?,
      nsfw: Bool?,
      postingRestrictedToMods: Bool?,
      discussionLanguages: [Int]?,
      onlyFollowersCanVote: Bool?,
      visibility: ApiCommunityVisibility?
    ) {
        self.body = .init(
          community_id: communityId,
          title: title,
          description: description,
          icon: icon,
          banner: banner,
          nsfw: nsfw,
          posting_restricted_to_mods: postingRestrictedToMods,
          discussion_languages: discussionLanguages,
          only_followers_can_vote: onlyFollowersCanVote,
          visibility: visibility
      )
    }
}
