//
//  Post+CacheExtensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-02.
//

import Foundation

extension Post1Providing {
    public var cacheId: Int { id }
    
    internal var apiTypeHash: Int {
        get { post1.apiTypeHash }
        set { post1.apiTypeHash = newValue }
    }
}

extension Post1: ApiBackedCacheIdentifiable {
    func update(with post: ApiPost, semaphore: UInt? = nil) {
        updated = post.updated
        title = post.name
        // We can't name this 'body' because @Observable uses that property name already
        content = post.body
        linkUrl = post.linkUrl
        embed = post.embed
        
        pinnedCommunity = post.featuredCommunity
        pinnedInstance = post.featuredLocal
        locked = post.locked
        nsfw = post.nsfw
        removed = post.removed
        thumbnailUrl = post.thumbnailImageUrl
        
        deletedManager.updateWithReceivedValue(post.deleted, semaphore: semaphore)
    }
}

extension Post2: ApiBackedCacheIdentifiable {
    func update(with post: ApiPostView, semaphore: UInt? = nil) {
        commentCount = post.counts.comments
        votesManager.updateWithReceivedValue(
            .init(from: post.counts, myVote: ScoringOperation.guaranteedInit(from: post.myVote)),
            semaphore: semaphore
        )
        
        unreadCommentCount = post.unreadComments
        savedManager.updateWithReceivedValue(post.saved, semaphore: semaphore)
        readManager.updateWithReceivedValue(post.read, semaphore: semaphore)
        hiddenManager.updateWithReceivedValue(post.hidden ?? false, semaphore: semaphore)

        post1.update(with: post.post, semaphore: semaphore)
        creator.update(with: post.creator, semaphore: semaphore)
        community.update(with: post.community, semaphore: semaphore)
        
        creator.blockedManager.updateWithReceivedValue(post.creatorBlocked, semaphore: semaphore)
    }
}
