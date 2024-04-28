//
//  ResolveCommentReportRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct ResolveCommentReportRequest: ApiPutRequest {
    typealias Body = ApiResolveCommentReport
    typealias Response = ApiCommentReportResponse

    let path = "comment/report/resolve"
    let body: Body?

    init(
      reportId: Int,
      resolved: Bool
    ) {
        self.body = .init(
          report_id: reportId,
          resolved: resolved
      )
    }
}
