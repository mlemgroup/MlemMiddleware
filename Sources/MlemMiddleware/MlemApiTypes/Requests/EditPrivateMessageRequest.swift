//
//  EditPrivateMessageRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct EditPrivateMessageRequest: ApiPutRequest {
    typealias Body = ApiEditPrivateMessage
    typealias Response = ApiPrivateMessageResponse

    let path = "private_message"
    let body: Body?

    init(
      privateMessageId: Int,
      content: String
    ) {
        self.body = .init(
          private_message_id: privateMessageId,
          content: content
      )
    }
}
