//
//  CommunityTier2.swift
//  Mlem
//
//  Created by Sjmarf on 03/02/2024.
//

import Observation

@Observable
public final class Community2: Community2Providing {
    public static let tierNumber: Int = 2
    public var community2: Community2 { self }
    public var api: ApiClient

    public let community1: Community1
    
    internal var subscriptionManager: StateManager<SubscriptionModel>
    internal var subscription: SubscriptionModel { subscriptionManager.wrappedValue }
    
    public var favorited: Bool {
        api.subscriptions?.isFavorited(self) ?? false
    }
    
    /// Used to state-fake internally.
    internal var shouldBeFavorited: Bool = false

    public var postCount: Int = 0
    public var commentCount: Int = 0
    public var activeUserCount: ActiveUserCount = .zero

    internal init(
        api: ApiClient,
        community1: Community1,
        subscription: SubscriptionModel,
        postCount: Int = 0,
        commentCount: Int = 0,
        activeUserCount: ActiveUserCount = .zero
    ) {
        self.api = api
        self.community1 = community1
        self.subscriptionManager = .init(wrappedValue: subscription)
        self.postCount = postCount
        self.commentCount = commentCount
        self.activeUserCount = activeUserCount
        
        if favorited, !subscribed {
            self.api.subscriptions?.favoriteIDs.remove(self.id)
        }
        self.subscriptionManager.onSet = { _, _ in
            self.api.subscriptions?.updateCommunitySubscription(community: self)
        }
        self.shouldBeFavorited = favorited
        self.subscriptionManager.onSet(subscription, .receive)
    }
}
