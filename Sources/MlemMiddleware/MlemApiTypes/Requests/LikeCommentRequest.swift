//
//  LikeCommentRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct LikeCommentRequest: ApiPostRequest {
    typealias Body = ApiCreateCommentLike
    typealias Response = ApiCommentResponse

    let path = "comment/like"
    let body: Body?

    init(
      commentId: Int,
      score: Int
    ) {
        self.body = .init(
          comment_id: commentId,
          score: score
      )
    }
}
