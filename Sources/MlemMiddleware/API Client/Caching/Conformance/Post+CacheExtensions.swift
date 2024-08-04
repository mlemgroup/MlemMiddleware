//
//  Post+CacheExtensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-02.
//

import Foundation

extension Post1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with post: ApiPost, semaphore: UInt? = nil) {
        setIfChanged(\.updated, post.updated)
        setIfChanged(\.title, post.name)
        // We can't name this 'body' because @Observable uses that property name already
        setIfChanged(\.content, post.body)
        setIfChanged(\.linkUrl, post.linkUrl)
        setIfChanged(\.embed, post.embed)
        
        setIfChanged(\.pinnedCommunity, post.featuredCommunity)
        setIfChanged(\.pinnedInstance, post.featuredLocal)
        setIfChanged(\.locked, post.locked)
        setIfChanged(\.nsfw, post.nsfw)
        setIfChanged(\.removed, post.removed)
        setIfChanged(\.thumbnailUrl, post.thumbnailImageUrl)
        
        deletedManager.updateWithReceivedValue(post.deleted, semaphore: semaphore)
    }
}

extension Post2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with post: ApiPostView, semaphore: UInt? = nil) {
        setIfChanged(\.commentCount, post.counts.comments)
        setIfChanged(\.unreadCommentCount, post.unreadComments)
        
        savedManager.updateWithReceivedValue(post.saved, semaphore: semaphore)
        readManager.updateWithReceivedValue(post.read, semaphore: semaphore)
        hiddenManager.updateWithReceivedValue(post.hidden ?? false, semaphore: semaphore)
        votesManager.updateWithReceivedValue(
            .init(from: post.counts, myVote: ScoringOperation.guaranteedInit(from: post.myVote)),
            semaphore: semaphore
        )
        creator.blockedManager.updateWithReceivedValue(post.creatorBlocked, semaphore: semaphore)

        post1.update(with: post.post, semaphore: semaphore)
        creator.update(with: post.creator, semaphore: semaphore)
        community.update(with: post.community, semaphore: semaphore)
    }
}
