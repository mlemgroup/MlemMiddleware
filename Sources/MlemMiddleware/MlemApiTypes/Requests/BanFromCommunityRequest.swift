//
//  BanFromCommunityRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct BanFromCommunityRequest: ApiPostRequest {
    typealias Body = ApiBanFromCommunity
    typealias Response = ApiBanFromCommunityResponse

    let path = "community/ban_user"
    let body: Body?

    init(
      communityId: Int,
      personId: Int,
      ban: Bool,
      removeData: Bool?,
      reason: String?,
      expires: Int?
    ) {
        self.body = .init(
          community_id: communityId,
          person_id: personId,
          ban: ban,
          remove_data: removeData,
          reason: reason,
          expires: expires
      )
    }
}
