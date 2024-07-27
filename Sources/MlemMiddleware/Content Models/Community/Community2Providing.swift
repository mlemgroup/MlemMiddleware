//
//  Community2Providing.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public protocol Community2Providing: Community1Providing {
    var community2: Community2 { get }
    
    var subscribed: Bool { get }
    var favorited: Bool { get }
    var subscriberCount: Int { get }
    var postCount: Int { get }
    var commentCount: Int { get }
    var activeUserCount: ActiveUserCount { get }
    
    @discardableResult
    func toggleSubscribe() -> Task<StateUpdateResult, Never>
    
    /// Favoriting a community also subscribes to it, if it is not subscribed already.
    @discardableResult
    func toggleFavorite() -> Task<StateUpdateResult, Never>
}

public extension Community2Providing {
    var community1: Community1 { community2.community1 }
    
    var subscribed: Bool { community2.subscribed }
    var favorited: Bool { community2.favorited }
    var subscriberCount: Int { community2.subscriberCount }
    var postCount: Int { community2.postCount }
    var commentCount: Int { community2.commentCount }
    var activeUserCount: ActiveUserCount { community2.activeUserCount }
    
    var subscribed_: Bool? { community2.subscribed }
    var favorited_: Bool? { community2.favorited }
    var subscriberCount_: Int? { community2.subscriberCount }
    var postCount_: Int? { community2.postCount }
    var commentCount_: Int? { community2.commentCount }
    var activeUserCount_: ActiveUserCount? { community2.activeUserCount }
    var subscriptionTier_: SubscriptionTier? { community2.subscriptionTier }
}

public extension Community2Providing {
    private var subscribedManager: StateManager<Bool> { community2.subscribedManager }
    
    var subscriptionTier: SubscriptionTier {
        if favorited { return .favorited }
        if subscribed { return .subscribed }
        return .unsubscribed
    }
    
    @discardableResult
    func toggleSubscribe() -> Task<StateUpdateResult, Never> {
        updateSubscribe(!subscribed)
    }
    
    @discardableResult
    func updateSubscribe(_ newValue: Bool) -> Task<StateUpdateResult, Never> {
        subscribedManager.performRequest(expectedResult: newValue) { semaphore in
            if !newValue {
                self.community2.shouldBeFavorited = false
            }
            try await self.api.subscribeToCommunity(id: self.id, subscribe: newValue, semaphore: semaphore)
        }
    }
    
    @discardableResult
    func toggleFavorite() -> Task<StateUpdateResult, Never> {
        updateFavorite(!favorited)
    }
    
    @discardableResult
    func updateFavorite(_ newValue: Bool) -> Task<StateUpdateResult, Never> {
        guard let subscriptions = self.api.subscriptions else {
            assertionFailure("Tried to toggle favorite, but no SubscriptionList found!")
            return Task { .failed }
        }
        self.community2.shouldBeFavorited = newValue
        if !subscribed, newValue {
            return subscribedManager.performRequest(expectedResult: true) { semaphore in
                subscriptions.updateCommunitySubscription(community: self.community2)
                try await self.api.subscribeToCommunity(id: self.id, subscribe: true, semaphore: semaphore)
            } onRollback: { _ in
                self.community2.shouldBeFavorited = false
            }
        } else {
            subscriptions.updateCommunitySubscription(community: self.community2)
            return Task { .succeeded }
        }
    }
}
