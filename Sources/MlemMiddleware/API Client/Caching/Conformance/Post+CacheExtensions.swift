//
//  Post+CacheExtensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-02.
//

import Foundation

extension Post1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with post: ApiPost) {
        updated = post.updated
    
        title = post.name
        
        // We can't name this 'body' because @Observable uses that property name already
        content = post.body
        
        linkUrl = post.linkUrl
        
        deleted = post.deleted
        
        embed = post.embed
        
        pinnedCommunity = post.featuredCommunity
        pinnedInstance = post.featuredLocal
        locked = post.locked
        nsfw = post.nsfw
        removed = post.removed
        thumbnailUrl = post.thumbnailImageUrl
    }
}

extension Post2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with post: ApiPostView, semaphore: UInt? = nil) {
        commentCount = post.counts.comments
        votesManager.updateWithReceivedValue(
            .init(from: post.counts, myVote: ScoringOperation.guaranteedInit(from: post.myVote)),
            semaphore: semaphore
        )
        unreadCommentCount = post.unreadComments
        savedManager.updateWithReceivedValue(post.saved, semaphore: semaphore)
        readManager.updateWithReceivedValue(post.read, semaphore: semaphore)

        post1.update(with: post.post)
        creator.update(with: post.creator)
        community.update(with: post.community)
        
        creator.blocked = post.creatorBlocked
    }
}
