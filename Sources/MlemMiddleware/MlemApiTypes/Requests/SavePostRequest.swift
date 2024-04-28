//
//  SavePostRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct SavePostRequest: ApiPutRequest {
    typealias Body = ApiSavePost
    typealias Response = ApiPostResponse

    let path = "post/save"
    let body: Body?

    init(
      postId: Int,
      save: Bool
    ) {
        self.body = .init(
          post_id: postId,
          save: save
      )
    }
}
