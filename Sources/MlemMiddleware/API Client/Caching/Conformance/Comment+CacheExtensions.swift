//
//  Comment+CacheExtensions.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

extension Comment1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with comment: ApiComment) {
        self.content = comment.content
        self.removed = comment.removed
        self.created = comment.published
        self.updated = comment.updated
        self.deleted = comment.deleted
        self.distinguished = comment.distinguished
        self.languageId = comment.languageId
    }
}

extension Comment2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with comment: ApiCommentView, semaphore: UInt? = nil) {
        self.comment1.update(with: comment.comment)
        self.creator.update(with: comment.creator)
        self.post.update(with: comment.post)
        self.community.update(with: comment.community)
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
