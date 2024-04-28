//
//  RemovePostRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct RemovePostRequest: ApiPostRequest {
    typealias Body = ApiRemovePost
    typealias Response = ApiPostResponse

    let path = "post/remove"
    let body: Body?

    init(
      postId: Int,
      removed: Bool,
      reason: String?
    ) {
        self.body = .init(
          post_id: postId,
          removed: removed,
          reason: reason
      )
    }
}
