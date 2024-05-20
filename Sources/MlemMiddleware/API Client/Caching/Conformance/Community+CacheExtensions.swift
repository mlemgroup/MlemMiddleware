//
//  Community+CacheExtensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-02.
//

import Foundation

extension Community1: CacheIdentifiable {
    public var cacheId: Int { actorId.hashValue }
    
    func update(with community: ApiCommunity) {
        updated = community.updated
        displayName = community.title
        description = community.description
        removed = community.removed
        deleted = community.deleted
        nsfw = community.nsfw
        avatar = community.icon
        banner = community.banner
        hidden = community.hidden
        onlyModeratorsCanPost = community.postingRestrictedToMods
        api.contentUpdateCallback(self)
    }
}

extension Community2: CacheIdentifiable {
    public var cacheId: Int { community1.cacheId }
    
    func update(with communityView: ApiCommunityView, semaphore: UInt? = nil) {
        subscribedManager.updateWithReceivedValue(communityView.subscribed.isSubscribed, semaphore: semaphore)
        subscriberCount = communityView.counts.subscribers
        postCount = communityView.counts.posts
        commentCount = communityView.counts.comments
        activeUserCount = .init(
            sixMonths: communityView.counts.usersActiveHalfYear,
            month: communityView.counts.usersActiveMonth,
            week: communityView.counts.usersActiveWeek,
            day: communityView.counts.usersActiveDay
        )
        community1.update(with: communityView.community)
    }
}

extension Community3: CacheIdentifiable {
    public var cacheId: Int { community2.cacheId }
    
    func update(with response: ApiGetCommunityResponse, semaphore: UInt? = nil) {
        moderators = response.moderators.map { moderatorView in
            api.caches.person1.performModelTranslation(api: api, from: moderatorView.moderator)
        }
        discussionLanguages = response.discussionLanguages
        community2.update(with: response.communityView, semaphore: semaphore)
    }
}
