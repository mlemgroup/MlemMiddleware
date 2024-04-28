//
//  AddModToCommunityRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct AddModToCommunityRequest: ApiPostRequest {
    typealias Body = ApiAddModToCommunity
    typealias Response = ApiAddModToCommunityResponse

    let path = "community/mod"
    let body: Body?

    init(
      communityId: Int,
      personId: Int,
      added: Bool
    ) {
        self.body = .init(
          community_id: communityId,
          person_id: personId,
          added: added
      )
    }
}
