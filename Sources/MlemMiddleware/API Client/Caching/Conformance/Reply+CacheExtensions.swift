//
//  Reply+CacheExtensions.swift
//
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation

extension Reply1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with reply: any Reply1ApiBacker) {
        self.read = reply.read
    }
}

extension Reply2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with reply: any Reply2ApiBacker, semaphore: UInt? = nil) {
        self.reply1.update(with: reply.reply)
        self.comment.update(with: reply.comment)
        self.creator.update(with: reply.creator)
        self.post.update(with: reply.post)
        self.community.update(with: reply.community)
        self.recipient.update(with: reply.recipient)
        self.subscribed = reply.subscribed.isSubscribed
        self.commentCount = reply.counts.childCount
        self.creatorIsModerator = reply.creatorIsModerator
        self.creatorIsAdmin = reply.creatorIsAdmin
        self.bannedFromCommunity = reply.bannedFromCommunity
        self.votesManager.updateWithReceivedValue(votes, semaphore: semaphore)
        self.savedManager.updateWithReceivedValue(saved, semaphore: semaphore)
    }
}
