//
//  DistinguishCommentRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct DistinguishCommentRequest: ApiPostRequest {
    typealias Body = ApiDistinguishComment
    typealias Response = ApiCommentResponse

    let path = "comment/distinguish"
    let body: Body?

    init(
      commentId: Int,
      distinguished: Bool
    ) {
        self.body = .init(
          comment_id: commentId,
          distinguished: distinguished
      )
    }
}
