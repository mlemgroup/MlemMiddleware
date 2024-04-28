//
//  MarkCommentReplyAsReadRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct MarkCommentReplyAsReadRequest: ApiPostRequest {
    typealias Body = ApiMarkCommentReplyAsRead
    typealias Response = ApiCommentReplyResponse

    let path = "comment/mark_as_read"
    let body: Body?

    init(
      commentReplyId: Int,
      read: Bool
    ) {
        self.body = .init(
          comment_reply_id: commentReplyId,
          read: read
      )
    }
}
