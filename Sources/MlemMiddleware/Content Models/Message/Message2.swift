//
//  Message2.swift
//
//
//  Created by Sjmarf on 05/07/2024.
//

import Foundation

@Observable
public final class Message2: Message2Providing {
    public static let tierNumber: Int = 2
    public var api: ApiClient
    public var message2: Message2 { self }
    
    public let message1: Message1
    public let creator: Person1
    public let recipient: Person1
    
    init(
        api: ApiClient,
        message1: Message1,
        creator: Person1,
        recipient: Person1
    ) {
        self.api = api
        self.message1 = message1
        self.creator = creator
        self.recipient = recipient
    }
}
