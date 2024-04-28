//
//  DeletePrivateMessageRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct DeletePrivateMessageRequest: ApiPostRequest {
    typealias Body = ApiDeletePrivateMessage
    typealias Response = ApiPrivateMessageResponse

    let path = "private_message/delete"
    let body: Body?

    init(
      privateMessageId: Int,
      deleted: Bool
    ) {
        self.body = .init(
          private_message_id: privateMessageId,
          deleted: deleted
      )
    }
}
