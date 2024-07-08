//
//  Reply1Providing.swift
//
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation

public protocol Reply1Providing:
        ContentModel,
        ContentIdentifiable,
        Interactable1Providing,
        InboxItemProviding
    {
    
    var reply1: Reply1 { get }
    
    var id: Int { get }
    var recipientId: Int { get }
    var commentId: Int { get }
    var read: Bool { get }
    var created: Date { get }
    var isMention: Bool { get }

    var id_: Int? { get }
    var recipientId_: Int? { get }
    var commentId_: Int? { get }
    var read_: Bool? { get }
    var created_: Date? { get }
    var isMention_: Bool? { get }
    
    // From Reply2Providing
    var comment_: Comment1? { get }
    var creator_: Person1? { get }
    var post_: Post1? { get }
    var community_: Community1? { get }
    var recipient_: Person1? { get }
    var subscribed_: Bool? { get }
    var commentCount_: Int? { get }
    var creatorIsModerator_: Bool? { get }
    var creatorIsAdmin_: Bool? { get }
    var bannedFromCommunity_: Bool? { get }
}

public typealias Reply = Reply1Providing

// Interactable1Providing conformance
public extension Reply1Providing {
    var updated: Date? { nil }
}

public extension Reply1Providing {
    static var modelTypeId: String { "reply" }
    
    var id: Int { reply1.id }
    var recipientId: Int { reply1.recipientId }
    var commentId: Int { reply1.commentId }
    var read: Bool { reply1.read }
    var created: Date { reply1.created }
    var isMention: Bool { reply1.isMention }
    
    var id_: Int? { id }
    var recipientId_: Int? { recipientId }
    var commentId_: Int? { commentId }
    var read_: Bool? { read }
    var created_: Date? { created }
    var isMention_: Bool? { isMention }
    
    // From Reply2Providing
    var comment_: Comment1? { nil }
    var creator_: Person1? { nil }
    var post_: Post1? { nil }
    var community_: Community1? { nil }
    var recipient_: Person1? { nil }
    var subscribed_: Bool? { nil }
    var commentCount_: Int? { nil }
    var creatorIsModerator_: Bool? { nil }
    var creatorIsAdmin_: Bool? { nil }
    var bannedFromCommunity_: Bool? { nil }
}

public extension Reply1Providing {
    private var readManager: StateManager<Bool> { reply1.readManager }
    
    // `toggleRead` is defined in `InboxItemProviding`
    func updateRead(_ newValue: Bool) {
        readManager.performRequest(expectedResult: newValue) { semaphore in
            if self.isMention {
                try await self.api.markMentionAsRead(id: self.id, read: newValue, semaphore: semaphore)
            } else {
                try await self.api.markReplyAsRead(id: self.id, read: newValue, semaphore: semaphore)
            }
        }
    }
    
 
}

// Override the `ContentIdentifiable` implementation to include `isMention`, because a reply
// and a mention can have the same ID
public extension Reply1Providing {
    var uid: Int {
        var hasher = Hasher()
        hasher.combine(Self.modelTypeId)
        hasher.combine(id)
        hasher.combine(isMention)
        return hasher.finalize()
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(api.actorId)
        hasher.combine(id)
        hasher.combine(self.isMention)
        hasher.combine(Self.modelTypeId)
        hasher.combine(Self.tierNumber)
    }
}
