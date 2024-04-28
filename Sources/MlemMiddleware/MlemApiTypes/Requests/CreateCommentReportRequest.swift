//
//  CreateCommentReportRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct CreateCommentReportRequest: ApiPostRequest {
    typealias Body = ApiCreateCommentReport
    typealias Response = ApiCommentReportResponse

    let path = "comment/report"
    let body: Body?

    init(
      commentId: Int,
      reason: String
    ) {
        self.body = .init(
          comment_id: commentId,
          reason: reason
      )
    }
}
