//
//  RemoveCommentRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct RemoveCommentRequest: ApiPostRequest {
    typealias Body = ApiRemoveComment
    typealias Response = ApiCommentResponse

    let path = "comment/remove"
    let body: Body?

    init(
      commentId: Int,
      removed: Bool,
      reason: String?
    ) {
        self.body = .init(
          comment_id: commentId,
          removed: removed,
          reason: reason
      )
    }
}
