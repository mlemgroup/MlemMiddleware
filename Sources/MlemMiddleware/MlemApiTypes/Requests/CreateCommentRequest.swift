//
//  CreateCommentRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct CreateCommentRequest: ApiPostRequest {
    typealias Body = ApiCreateComment
    typealias Response = ApiCommentResponse

    let path = "comment"
    let body: Body?

    init(
      content: String,
      postId: Int,
      parentId: Int?,
      languageId: Int?,
      formId: String?
    ) {
        self.body = .init(
          content: content,
          post_id: postId,
          parent_id: parentId,
          language_id: languageId,
          form_id: formId
      )
    }
}
