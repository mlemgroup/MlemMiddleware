//
//  Message+CacheExtensions.swift
//
//
//  Created by Sjmarf on 05/07/2024.
//

import Foundation

extension Message1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with message: ApiPrivateMessage, semaphore: UInt? = nil) {
        self.content = message.content
        self.deleted = message.deleted
        self.updated = message.updated
        self.readManager.updateWithReceivedValue(message.read, semaphore: semaphore)
    }
}

extension Message2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with message: ApiPrivateMessageView, semaphore: UInt? = nil) {
        self.message1.update(with: message.privateMessage)
        self.creator.update(with: message.creator, semaphore: semaphore)
        self.recipient.update(with: message.recipient, semaphore: semaphore)
    }
}
