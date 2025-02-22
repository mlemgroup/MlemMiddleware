//
//  Community+CacheExtensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-02.
//

import Foundation

extension Community1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    @MainActor
    func update(with community: ApiCommunity, semaphore: UInt? = nil) {
        setIfChanged(\.updated, community.updated)
        setIfChanged(\.displayName, community.title)
        setIfChanged(\.description, community.description)
        removedManager.updateWithReceivedValue(community.removed, semaphore: semaphore)
        setIfChanged(\.deleted, community.deleted)
        setIfChanged(\.nsfw, community.nsfw)
        setIfChanged(\.avatar, community.icon)
        setIfChanged(\.banner, community.banner)
        setIfChanged(\.hidden, community.hidden)
        setIfChanged(\.onlyModeratorsCanPost, community.postingRestrictedToMods)
    }
}

extension Community2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    @MainActor
    func update(with communityView: ApiCommunityView, semaphore: UInt? = nil) {
        setIfChanged(\.postCount, communityView.resolvedCounts.posts)
        setIfChanged(\.commentCount, communityView.resolvedCounts.comments)
        setIfChanged(\.activeUserCount, .init(
            sixMonths: communityView.resolvedCounts.usersActiveHalfYear,
            month: communityView.resolvedCounts.usersActiveMonth,
            week: communityView.resolvedCounts.usersActiveWeek,
            day: communityView.resolvedCounts.usersActiveDay
        ))
        
        subscriptionManager.updateWithReceivedValue(
            .init(from: communityView.resolvedCounts, subscribedType: communityView.subscribed),
            semaphore: semaphore
        )
        
        community1.update(with: communityView.community, semaphore: semaphore)
    }
}

extension Community3: CacheIdentifiable {
    public var cacheId: Int { id }
    
    @MainActor
    func update(with response: ApiGetCommunityResponse, semaphore: UInt? = nil) {
        setIfChanged(\.moderators, response.moderators.map { moderatorView in
            api.caches.person1.performModelTranslation(api: api, from: moderatorView.moderator)
        })
        setIfChanged(\.discussionLanguages, response.discussionLanguages)

        community2.update(with: response.communityView, semaphore: semaphore)
    }
}
