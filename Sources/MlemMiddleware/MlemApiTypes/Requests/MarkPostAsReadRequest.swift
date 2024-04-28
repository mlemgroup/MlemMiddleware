//
//  MarkPostAsReadRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct MarkPostAsReadRequest: ApiPostRequest {
    typealias Body = ApiMarkPostAsRead
    typealias Response = ApiSuccessResponse

    let path = "post/mark_as_read"
    let body: Body?

    init(
      postId: Int?,
      read: Bool,
      postIds: [Int]?
    ) {
        self.body = .init(
          post_id: postId,
          read: read,
          post_ids: postIds
      )
    }
}
