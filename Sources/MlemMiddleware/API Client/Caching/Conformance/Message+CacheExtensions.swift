//
//  Message+CacheExtensions.swift
//
//
//  Created by Sjmarf on 05/07/2024.
//

import Foundation

extension Message1Providing {
    public var cacheId: Int { id }
    
    internal var apiTypeHash: Int {
        get { message1.apiTypeHash }
        set { message1.apiTypeHash = newValue }
    }
}

extension Message1: ApiBackedCacheIdentifiable {
    func update(with message: ApiPrivateMessage, semaphore: UInt? = nil) {
        self.content = message.content
        self.deletedManager.updateWithReceivedValue(message.deleted, semaphore: semaphore)
        self.updated = message.updated
        self.readManager.updateWithReceivedValue(message.read, semaphore: semaphore)
    }
}

extension Message2: ApiBackedCacheIdentifiable {
    func update(with message: ApiPrivateMessageView, semaphore: UInt? = nil) {
        self.message1.update(with: message.privateMessage, semaphore: semaphore)
        self.creator.update(with: message.creator, semaphore: semaphore)
        self.recipient.update(with: message.recipient, semaphore: semaphore)
    }
}
