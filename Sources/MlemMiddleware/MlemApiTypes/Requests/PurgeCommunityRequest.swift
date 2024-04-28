//
//  PurgeCommunityRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct PurgeCommunityRequest: ApiPostRequest {
    typealias Body = ApiPurgeCommunity
    typealias Response = ApiSuccessResponse

    let path = "admin/purge/community"
    let body: Body?

    init(
      communityId: Int,
      reason: String?
    ) {
        self.body = .init(
          community_id: communityId,
          reason: reason
      )
    }
}
