//
//  PostCaches.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-01.
//

import Foundation

class Post1Cache: ApiTypeBackedCache<Post1, ApiPost> {
    override func performModelTranslation(api: ApiClient, from apiType: ApiPost) -> Post1 {
        .init(
            api: api,
            actorId: apiType.actorId,
            id: apiType.id,
            creatorId: apiType.creatorId,
            communityId: apiType.communityId,
            created: apiType.published,
            title: apiType.name,
            content: apiType.body,
            linkUrl: apiType.linkUrl,
            deleted: apiType.deleted,
            embed: apiType.embed,
            pinnedCommunity: apiType.featuredCommunity,
            pinnedInstance: apiType.featuredLocal,
            locked: apiType.locked,
            nsfw: apiType.nsfw,
            removed: apiType.removed,
            thumbnailUrl: apiType.thumbnailImageUrl,
            updated: apiType.updated
        )
    }
    
    override func updateModel(_ item: Post1, with apiType: ApiPost, semaphore: UInt? = nil) {
        item.update(with: apiType, semaphore: semaphore)
    }
}

class Post2Cache: ApiTypeBackedCache<Post2, ApiPostView> {
    override func performModelTranslation(api: ApiClient, from apiType: ApiPostView) -> Post2 {
        .init(
            api: api,
            post1: api.caches.post1.getModel(api: api, from: apiType.post),
            creator: api.caches.person1.getModel(api: api, from: apiType.creator),
            community: api.caches.community1.getModel(api: api, from: apiType.community),
            votes: .init(from: apiType.counts, myVote: ScoringOperation.guaranteedInit(from: apiType.myVote)),
            commentCount: apiType.counts.comments,
            unreadCommentCount: apiType.unreadComments,
            saved: apiType.saved,
            read: apiType.read,
            hidden: apiType.hidden ?? false
        )
    }
    
    override func updateModel(_ item: Post2, with apiType: ApiPostView, semaphore: UInt? = nil) {
        item.update(with: apiType, semaphore: semaphore)
    }
}
