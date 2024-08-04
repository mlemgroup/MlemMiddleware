//
//  Comment+CacheExtensions.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

extension Comment1Providing {
    public var cacheId: Int { id }
    
    internal var apiTypeHash: Int {
        get { comment1.apiTypeHash }
        set { comment1.apiTypeHash = newValue }
    }
}

extension Comment1: ApiBackedCacheIdentifiable {
    func update(with comment: ApiComment, semaphore: UInt? = nil) {
        self.content = comment.content
        self.removed = comment.removed
        self.created = comment.published
        self.updated = comment.updated
        self.deletedManager.updateWithReceivedValue(comment.deleted, semaphore: semaphore)
        self.distinguished = comment.distinguished
        self.languageId = comment.languageId
    }
}

extension Comment2: ApiBackedCacheIdentifiable {
    func update(with comment: ApiCommentView, semaphore: UInt? = nil) {
        self.comment1.update(with: comment.comment, semaphore: semaphore)
        self.creator.update(with: comment.creator, semaphore: semaphore)
        self.post.update(with: comment.post, semaphore: semaphore)
        self.community.update(with: comment.community, semaphore: semaphore)
        votesManager.updateWithReceivedValue(
            .init(from: comment.counts, myVote: ScoringOperation.guaranteedInit(from: comment.myVote)),
            semaphore: semaphore
        )
        savedManager.updateWithReceivedValue(comment.saved, semaphore: semaphore)
        self.creatorIsModerator = comment.creatorIsModerator
        self.creatorIsAdmin = comment.creatorIsAdmin
        self.bannedFromCommunity = comment.bannedFromCommunity
        self.commentCount = comment.counts.childCount
    }
}
