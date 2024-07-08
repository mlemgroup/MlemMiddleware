//
//  Message1Providing.swift
//
//
//  Created by Sjmarf on 05/07/2024.
//

import Foundation

public protocol Message1Providing:
        ContentModel,
        ActorIdentifiable,
        ContentIdentifiable,
        InboxItemProviding,
        SelectableContentProviding
    {
    
    var message1: Message1 { get }
    
    var id: Int { get }
    var creatorId: Int { get }
    var recipientId: Int { get }
    var content: String { get }
    var deleted: Bool { get }
    var created: Date { get }
    var updated: Date? { get }
    var read: Bool { get }
    
    var id_: Int? { get }
    var creatorId_: Int? { get }
    var recipientId_: Int? { get }
    var content_: String? { get }
    var deleted_: Bool? { get }
    var created_: Date? { get }
    var updated_: Date? { get }
    var read_: Bool? { get }
    
    // From Message2Providing
    var creator_: Person1? { get }
    var recipient_: Person1? { get }
}

public typealias Message = Message1Providing

// SelectableContentProviding conformance
public extension Message1Providing {
    var selectableContent: String? { content }
}

public extension Message1Providing {
    static var modelTypeId: String { "message" }
    
    var actorId: URL { message1.actorId }
    var id: Int { message1.id }
    var creatorId: Int { message1.creatorId }
    var recipientId: Int { message1.recipientId }
    var content: String { message1.content }
    var deleted: Bool { message1.deleted }
    var created: Date { message1.created }
    var updated: Date? { message1.updated }
    var read: Bool { message1.read }
    
    var id_: Int? { message1.id }
    var creatorId_: Int? { message1.creatorId }
    var recipientId_: Int? { message1.recipientId }
    var content_: String? { message1.content }
    var deleted_: Bool? { message1.deleted }
    var created_: Date? { message1.created }
    var updated_: Date? { message1.updated }
    var read_: Bool? { message1.read }
    
    var creator_: Person1? { nil }
    var recipient_: Person1? { nil }
}

public extension Message1Providing {
    private var readManager: StateManager<Bool> { message1.readManager }
    
    // `toggleRead` is defined in `InboxItemProviding`
    func updateRead(_ newValue: Bool) {
        readManager.performRequest(expectedResult: newValue) { semaphore in
            try await self.api.markMessageAsRead(id: self.id, read: newValue, semaphore: semaphore)
        }
    }
}
