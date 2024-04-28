//
//  CreatePostRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct CreatePostRequest: ApiPostRequest {
    typealias Body = ApiCreatePost
    typealias Response = ApiPostResponse

    let path = "post"
    let body: Body?

    init(
      name: String,
      communityId: Int,
      url: String?,
      body: String?,
      honeypot: String?,
      nsfw: Bool?,
      languageId: Int?,
      altText: String?,
      customThumbnail: String?
    ) {
        self.body = .init(
          name: name,
          community_id: communityId,
          url: url,
          body: body,
          honeypot: honeypot,
          nsfw: nsfw,
          language_id: languageId,
          alt_text: altText,
          custom_thumbnail: customThumbnail
      )
    }
}
