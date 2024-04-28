//
//  CreatePostReportRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct CreatePostReportRequest: ApiPostRequest {
    typealias Body = ApiCreatePostReport
    typealias Response = ApiPostReportResponse

    let path = "post/report"
    let body: Body?

    init(
      postId: Int,
      reason: String
    ) {
        self.body = .init(
          post_id: postId,
          reason: reason
      )
    }
}
