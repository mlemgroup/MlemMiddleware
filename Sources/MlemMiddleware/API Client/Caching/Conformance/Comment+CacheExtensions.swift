//
//  Comment+CacheExtensions.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

extension Comment1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with comment: ApiComment, semaphore: UInt? = nil) {
        setIfChanged(\.content, comment.content)
        setIfChanged(\.removed, comment.removed)
        setIfChanged(\.created, comment.published)
        setIfChanged(\.updated, comment.updated)
        setIfChanged(\.distinguished, comment.distinguished)
        setIfChanged(\.languageId, comment.languageId)

        self.deletedManager.updateWithReceivedValue(comment.deleted, semaphore: semaphore)
    }
}

extension Comment2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with comment: ApiCommentView, semaphore: UInt? = nil) {
        setIfChanged(\.creatorIsModerator, comment.creatorIsModerator)
        setIfChanged(\.creatorIsAdmin, comment.creatorIsAdmin)
        setIfChanged(\.creatorIsModerator, comment.creatorIsModerator)
        setIfChanged(\.creatorIsModerator, comment.creatorIsModerator)
        setIfChanged(\.creatorIsAdmin, comment.creatorIsAdmin)
        setIfChanged(\.bannedFromCommunity, comment.bannedFromCommunity)
        setIfChanged(\.commentCount, comment.counts.childCount)

        votesManager.updateWithReceivedValue(
            .init(from: comment.counts, myVote: ScoringOperation.guaranteedInit(from: comment.myVote)),
            semaphore: semaphore
        )
        savedManager.updateWithReceivedValue(comment.saved, semaphore: semaphore)
        
        self.comment1.update(with: comment.comment, semaphore: semaphore)
        self.creator.update(with: comment.creator, semaphore: semaphore)
        self.post.update(with: comment.post, semaphore: semaphore)
        self.community.update(with: comment.community, semaphore: semaphore)
    }
}
