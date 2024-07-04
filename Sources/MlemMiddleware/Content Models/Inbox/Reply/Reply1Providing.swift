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
        Interactable1Providing
    {
    
    var reply1: Reply1 { get }
    
    var id: Int { get }
    var recipientId: Int { get }
    var commentId: Int { get }
    var read: Bool { get }
    var created: Date { get }

    var id_: Int? { get }
    var recipientId_: Int? { get }
    var commentId_: Int? { get }
    var read_: Bool? { get }
    var created_: Date? { get }
    
    // From Reply2Providing
    var reply1_: Reply1? { get }
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
    
    var id_: Int? { id }
    var recipientId_: Int? { recipientId }
    var commentId_: Int? { commentId }
    var read_: Bool? { read }
    var created_: Date? { created }
    
    // From Reply2Providing
    var reply1_: Reply1? { nil }
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
