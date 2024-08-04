//
//  Reply+CacheExtensions.swift
//
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation

extension Reply1Providing {
    public var cacheId: Int { id }
    
    internal var apiTypeHash: Int {
        get { reply1.apiTypeHash }
        set { reply1.apiTypeHash = newValue }
    }
}

extension Reply1: ApiBackedCacheIdentifiable {
    func update(with reply: any Reply1ApiBacker, semaphore: UInt? = nil) {
        self.readManager.updateWithReceivedValue(reply.read, semaphore: semaphore)
    }
}

extension Reply2: ApiBackedCacheIdentifiable {
    func update(with reply: any Reply2ApiBacker, semaphore: UInt? = nil) {
        self.reply1.update(with: reply.reply, semaphore: semaphore)
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
