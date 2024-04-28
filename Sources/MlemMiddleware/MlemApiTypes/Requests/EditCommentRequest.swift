//
//  EditCommentRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct EditCommentRequest: ApiPutRequest {
    typealias Body = ApiEditComment
    typealias Response = ApiCommentResponse

    let path = "comment"
    let body: Body?

    init(
      commentId: Int,
      content: String?,
      languageId: Int?,
      formId: String?
    ) {
        self.body = .init(
          comment_id: commentId,
          content: content,
          language_id: languageId,
          form_id: formId
      )
    }
}
