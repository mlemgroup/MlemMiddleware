//
//  MessageCaches.swift
//
//
//  Created by Sjmarf on 05/07/2024.
//

import Foundation

class Message1Cache: ApiTypeBackedCache<Message1, ApiPrivateMessage> {
    override func performModelTranslation(api: ApiClient, from apiType: ApiPrivateMessage) -> Message1 {
        .init(
            api: api,
            actorId: apiType.apId,
            id: apiType.id,
            creatorId: apiType.creatorId,
            recipientId: apiType.recipientId,
            content: apiType.content,
            deleted: apiType.deleted,
            created: apiType.published,
            updated: apiType.updated,
            read: (api.myPerson?.id == apiType.creatorId) ? true : apiType.read
        )
    }
    
    override func updateModel(_ item: Message1, with apiType: ApiPrivateMessage, semaphore: UInt? = nil) {
        item.update(with: apiType)
    }
}

class Message2Cache: ApiTypeBackedCache<Message2, ApiPrivateMessageView> {
    override func performModelTranslation(api: ApiClient, from apiType: ApiPrivateMessageView) -> Message2 {
        .init(
            api: api,
            message1: api.caches.message1.getModel(api: api, from: apiType.privateMessage),
            creator: api.caches.person1.getModel(api: api, from: apiType.creator),
            recipient: api.caches.person1.getModel(api: api, from: apiType.recipient)
        )
    }
    
    override func updateModel(_ item: Message2, with apiType: ApiPrivateMessageView, semaphore: UInt? = nil) {
        item.update(with: apiType, semaphore: semaphore)
    }
}
