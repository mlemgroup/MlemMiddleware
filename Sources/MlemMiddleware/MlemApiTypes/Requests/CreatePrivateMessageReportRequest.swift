//
//  CreatePrivateMessageReportRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct CreatePrivateMessageReportRequest: ApiPostRequest {
    typealias Body = ApiCreatePrivateMessageReport
    typealias Response = ApiPrivateMessageReportResponse

    let path = "private_message/report"
    let body: Body?

    init(
      privateMessageId: Int,
      reason: String
    ) {
        self.body = .init(
          private_message_id: privateMessageId,
          reason: reason
      )
    }
}
