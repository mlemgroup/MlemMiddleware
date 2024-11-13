//
//  Reply+CacheExtensions.swift
//
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation

extension Reply1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with reply: any Reply1ApiBacker, semaphore: UInt? = nil) {
        self.readManager.updateWithReceivedValue(reply.read, semaphore: semaphore)
    }
}

extension Reply2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with reply: any Reply2ApiBacker, semaphore: UInt? = nil) {
        setIfChanged(\.self.subscribed, reply.subscribed.isSubscribed)
        setIfChanged(\.self.commentCount, reply.counts.childCount)
        setIfChanged(\.self.creatorIsModerator, reply.creatorIsModerator)
        setIfChanged(\.self.creatorIsAdmin, reply.creatorIsAdmin)
        creator.updateKnownCommunityBanState(id: community.id, banned: reply.bannedFromCommunity ?? reply.creatorBannedFromCommunity)
        
        self.votesManager.updateWithReceivedValue(votes, semaphore: semaphore)
        self.savedManager.updateWithReceivedValue(saved, semaphore: semaphore)
        
        self.reply1.update(with: reply.reply, semaphore: semaphore)
        self.comment.update(with: reply.comment)
        self.creator.update(with: reply.creator)
        self.post.update(with: reply.post)
        self.community.update(with: reply.community)
        self.recipient.update(with: reply.recipient)
    }
}
