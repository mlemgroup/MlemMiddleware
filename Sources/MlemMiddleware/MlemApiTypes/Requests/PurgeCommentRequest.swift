//
//  PurgeCommentRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct PurgeCommentRequest: ApiPostRequest {
    typealias Body = ApiPurgeComment
    typealias Response = ApiSuccessResponse

    let path = "admin/purge/comment"
    let body: Body?

    init(
      commentId: Int,
      reason: String?
    ) {
        self.body = .init(
          comment_id: commentId,
          reason: reason
      )
    }
}
