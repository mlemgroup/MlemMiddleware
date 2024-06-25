//
//  CommentCaches.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

class Comment1Cache: ApiTypeBackedCache<Comment1, ApiComment> {
    override func performModelTranslation(api: ApiClient, from apiType: ApiComment) -> Comment1 {
        return .init(
            api: api,
            actorId: apiType.actorId,
            id: apiType.id,
            content: apiType.content,
            removed: apiType.removed,
            created: apiType.published,
            updated: apiType.updated,
            deleted: apiType.deleted,
            creatorId: apiType.creatorId,
            postId: apiType.postId,
            parentCommentIds: Array(apiType.path.split(separator: ".").compactMap { Int($0) }.dropFirst()),
            distinguished: apiType.distinguished,
            languageId: apiType.languageId
        )
    }
    
    override func updateModel(_ item: Comment1, with apiType: ApiComment, semaphore: UInt? = nil) {
        item.update(with: apiType)
    }
}

class Comment2Cache: ApiTypeBackedCache<Comment2, ApiCommentView> {
    let post1Cache: Post1Cache
    let comment1Cache: Comment1Cache
    let person1Cache: Person1Cache
    let community1Cache: Community1Cache
    
    init(
        comment1Cache: Comment1Cache,
        post1Cache: Post1Cache,
        person1Cache: Person1Cache,
        community1Cache: Community1Cache
    ) {
        self.comment1Cache = comment1Cache
        self.post1Cache = post1Cache
        self.person1Cache = person1Cache
        self.community1Cache = community1Cache
    }
    
    override func performModelTranslation(api: ApiClient, from apiType: ApiCommentView) -> Comment2 {
        .init(
            api: api,
            comment1: comment1Cache.getModel(api: api, from: apiType.comment),
            creator: person1Cache.getModel(api: api, from: apiType.creator),
            post: post1Cache.getModel(api: api, from: apiType.post),
            community: community1Cache.getModel(api: api, from: apiType.community),
            votes: .init(from: apiType.counts, myVote: ScoringOperation.guaranteedInit(from: apiType.myVote)),
            saved: apiType.saved,
            creatorIsModerator: apiType.creatorIsModerator,
            creatorIsAdmin: apiType.creatorIsAdmin,
            bannedFromCommunity: apiType.bannedFromCommunity,
            commentCount: apiType.counts.childCount
        )
    }
    
    override func updateModel(_ item: Comment2, with apiType: ApiCommentView, semaphore: UInt? = nil) {
        item.update(with: apiType, semaphore: semaphore)
    }
}
