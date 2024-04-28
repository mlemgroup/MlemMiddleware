//
//  EditPostRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct EditPostRequest: ApiPutRequest {
    typealias Body = ApiEditPost
    typealias Response = ApiPostResponse

    let path = "post"
    let body: Body?

    init(
      postId: Int,
      name: String?,
      url: String?,
      body: String?,
      nsfw: Bool?,
      languageId: Int?,
      altText: String?,
      customThumbnail: String?
    ) {
        self.body = .init(
          post_id: postId,
          name: name,
          url: url,
          body: body,
          nsfw: nsfw,
          language_id: languageId,
          alt_text: altText,
          custom_thumbnail: customThumbnail
      )
    }
}
