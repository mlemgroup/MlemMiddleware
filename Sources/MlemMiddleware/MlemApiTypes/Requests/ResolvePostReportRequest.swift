//
//  ResolvePostReportRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct ResolvePostReportRequest: ApiPutRequest {
    typealias Body = ApiResolvePostReport
    typealias Response = ApiPostReportResponse

    let path = "post/report/resolve"
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
