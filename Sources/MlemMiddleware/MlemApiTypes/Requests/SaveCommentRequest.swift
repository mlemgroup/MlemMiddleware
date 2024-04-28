//
//  SaveCommentRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct SaveCommentRequest: ApiPutRequest {
    typealias Body = ApiSaveComment
    typealias Response = ApiCommentResponse

    let path = "comment/save"
    let body: Body?

    init(
      commentId: Int,
      save: Bool
    ) {
        self.body = .init(
          comment_id: commentId,
          save: save
      )
    }
}
