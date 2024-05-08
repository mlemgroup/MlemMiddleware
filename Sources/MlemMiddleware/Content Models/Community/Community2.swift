//
//  CommunityTier2.swift
//  Mlem
//
//  Created by Sjmarf on 03/02/2024.
//

import Observation
import SwiftUI

@Observable
public final class Community2: Community2Providing {
    public var community2: Community2 { self }
    public var api: ApiClient

    public let community1: Community1
    
    internal var subscribedManager: StateManager<Bool>
    public var subscribed: Bool { subscribedManager.wrappedValue }
    
    public var favorited: Bool {
        api.subscriptions?.isFavorited(self) ?? false
    }
    
    /// Used to state-fake internally.
    internal var shouldBeFavorited: Bool = false

    public var subscriberCount: Int = 0
    public var postCount: Int = 0
    public var commentCount: Int = 0
    public var activeUserCount: ActiveUserCount = .zero

    internal init(
        api: ApiClient,
        community1: Community1,
        subscribed: Bool = false,
        subscriberCount: Int = 0,
        postCount: Int = 0,
        commentCount: Int = 0,
        activeUserCount: ActiveUserCount = .zero
    ) {
        self.api = api
        self.community1 = community1
        self.subscribedManager = .init(wrappedValue: subscribed)
        self.subscriberCount = subscriberCount
        self.postCount = postCount
        self.commentCount = commentCount
        self.activeUserCount = activeUserCount
        
        if favorited, !subscribed {
            self.api.subscriptions?.favoriteIDs.remove(self.id)
        }
        self.subscribedManager.onSet = { newValue in
            self.api.subscriptions?.updateCommunitySubscription(community: self)
        }
        self.shouldBeFavorited = favorited
        self.subscribedManager.onSet(subscribed)
    }
}
