//
//  Message1.swift
//
//
//  Created by Sjmarf on 05/07/2024.
//

import Foundation
import Observation

@Observable
public final class Message1: Message1Providing {
    public static let tierNumber: Int = 1
    public var api: ApiClient
    public var message1: Message1 { self }
    
    public let actorId: URL
    public let id: Int
    public let creatorId: Int
    public let recipientId: Int
    public var content: String
    public var deleted: Bool
    public let created: Date
    public var updated: Date?
    
    internal let readManager: StateManager<Bool>
    public var read: Bool { readManager.wrappedValue }
    
    init(api: ApiClient, 
         actorId: URL,
         id: Int,
         creatorId: Int,
         recipientId: Int,
         content: String,
         deleted: Bool,
         created: Date,
         updated: Date?,
         read: Bool
    ) {
        self.api = api
        self.actorId = actorId
        self.id = id
        self.creatorId = creatorId
        self.recipientId = recipientId
        self.content = content
        self.deleted = deleted
        self.created = created
        self.updated = updated
        self.readManager = .init(wrappedValue: read)
    }
}
