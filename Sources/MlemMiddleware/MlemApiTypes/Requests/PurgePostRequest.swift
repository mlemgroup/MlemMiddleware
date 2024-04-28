//
//  PurgePostRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct PurgePostRequest: ApiPostRequest {
    typealias Body = ApiPurgePost
    typealias Response = ApiSuccessResponse

    let path = "admin/purge/post"
    let body: Body?

    init(
      postId: Int,
      reason: String?
    ) {
        self.body = .init(
          post_id: postId,
          reason: reason
      )
    }
}
