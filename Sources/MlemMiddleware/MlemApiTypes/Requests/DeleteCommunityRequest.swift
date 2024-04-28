//
//  DeleteCommunityRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct DeleteCommunityRequest: ApiPostRequest {
    typealias Body = ApiDeleteCommunity
    typealias Response = ApiCommunityResponse

    let path = "community/delete"
    let body: Body?

    init(
      communityId: Int,
      deleted: Bool
    ) {
        self.body = .init(
          community_id: communityId,
          deleted: deleted
      )
    }
}
