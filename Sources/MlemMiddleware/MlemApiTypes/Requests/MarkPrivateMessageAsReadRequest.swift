//
//  MarkPrivateMessageAsReadRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct MarkPrivateMessageAsReadRequest: ApiPostRequest {
    typealias Body = ApiMarkPrivateMessageAsRead
    typealias Response = ApiPrivateMessageResponse

    let path = "private_message/mark_as_read"
    let body: Body?

    init(
      privateMessageId: Int,
      read: Bool
    ) {
        self.body = .init(
          private_message_id: privateMessageId,
          read: read
      )
    }
}
