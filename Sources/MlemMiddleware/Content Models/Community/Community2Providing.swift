//
//  Community2Providing.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation
import SwiftUI

public struct ActiveUserCount {
    let sixMonths: Int
    let month: Int
    let week: Int
    let day: Int
    
    public static let zero: ActiveUserCount = .init(sixMonths: 0, month: 0, week: 0, day: 0)
}

public protocol Community2Providing: Community1Providing {
    var community2: Community2 { get }
    
    var isSubscribed: Bool { get }
    var isFavorited: Bool { get }
    var subscriberCount: Int { get }
    var postCount: Int { get }
    var commentCount: Int { get }
    var activeUserCount: ActiveUserCount { get }
}

public extension Community2Providing {
    var community1: Community1 { community2.community1 }
    
    var isSubscribed: Bool { community2.isSubscribed }
    var isFavorited: Bool { community2.isFavorited }
    var subscriberCount: Int { community2.subscriberCount }
    var postCount: Int { community2.postCount }
    var commentCount: Int { community2.commentCount }
    var activeUserCount: ActiveUserCount { community2.activeUserCount }
    
    var isSubscribed_: Bool? { community2.isSubscribed }
    var isFavorited_: Bool? { community2.isFavorited }
    var subscriberCount_: Int? { community2.subscriberCount }
    var postCount_: Int? { community2.postCount }
    var commentCount_: Int? { community2.commentCount }
    var activeUserCount_: ActiveUserCount? { community2.activeUserCount }
    var subscriptionTier_: SubscriptionTier? { community2.subscriptionTier }
}

public extension Community2Providing {
    var subscriptionTier: SubscriptionTier {
        if isFavorited { return .favorited }
        if isSubscribed { return .subscribed }
        return .unsubscribed
    }
}
