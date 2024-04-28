//
//  RemoveCommunityRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct RemoveCommunityRequest: ApiPostRequest {
    typealias Body = ApiRemoveCommunity
    typealias Response = ApiCommunityResponse

    let path = "community/remove"
    let body: Body?

    init(
      communityId: Int,
      removed: Bool,
      reason: String?,
      expires: Int?
    ) {
        self.body = .init(
          community_id: communityId,
          removed: removed,
          reason: reason,
          expires: expires
      )
    }
}
