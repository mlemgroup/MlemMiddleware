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
    
    public let actorId: ActorIdentifier
    public let id: Int
    public let creatorId: Int
    public let recipientId: Int
    public var content: String
    public let created: Date
    public var updated: Date?
    public let isOwnMessage: Bool
    
    internal let readManager: StateManager<Bool>
    public var read: Bool { readManager.wrappedValue }
    
    internal var deletedManager: StateManager<Bool>
    public var deleted: Bool { deletedManager.wrappedValue }
    
    init(api: ApiClient, 
         actorId: ActorIdentifier,
         id: Int,
         creatorId: Int,
         recipientId: Int,
         isOwnMessage: Bool,
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
        self.isOwnMessage = isOwnMessage
        self.content = content
        self.deletedManager = .init(wrappedValue: deleted)
        self.created = created
        self.updated = updated
        self.readManager = .init(wrappedValue: isOwnMessage ? true : read)
        self.readManager.onSet = { newValue, type, semaphore in
            if type == .begin || type == .rollback {
                api.unreadCount?.updateUnverifiedItem(itemType: .message, isRead: newValue)
            }
        }
        self.readManager.onVerify = { newValue, semaphore in
            api.unreadCount?.verifyItem(itemType: .message, isRead: newValue)
        }
    }
}
