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
    
    internal var isSubscribedManager: StateManager<Bool>
    public var isSubscribed: Bool { isSubscribedManager.wrappedValue }
    
    public var isFavorited: Bool = false

    public var subscriberCount: Int = 0
    public var postCount: Int = 0
    public var commentCount: Int = 0
    public var activeUserCount: ActiveUserCount = .zero

    public init(
        api: ApiClient,
        community1: Community1,
        isSubscribed: Bool = false,
        isFavorited: Bool = false,
        subscriberCount: Int = 0,
        postCount: Int = 0,
        commentCount: Int = 0,
        activeUserCount: ActiveUserCount = .zero
    ) {
        self.api = api
        self.community1 = community1
        self.isSubscribedManager = .init(wrappedValue: isSubscribed)
        self.isFavorited = isFavorited
        self.subscriberCount = subscriberCount
        self.postCount = postCount
        self.commentCount = commentCount
        self.activeUserCount = activeUserCount
    }
}
