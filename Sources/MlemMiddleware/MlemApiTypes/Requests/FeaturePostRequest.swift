//
//  FeaturePostRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct FeaturePostRequest: ApiPostRequest {
    typealias Body = ApiFeaturePost
    typealias Response = ApiPostResponse

    let path = "post/feature"
    let body: Body?

    init(
      postId: Int,
      featured: Bool,
      featureType: ApiPostFeatureType
    ) {
        self.body = .init(
          post_id: postId,
          featured: featured,
          feature_type: featureType
      )
    }
}
