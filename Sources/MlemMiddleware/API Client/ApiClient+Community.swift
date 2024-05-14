//
//  NewApiClient+Requests.swift
//  Mlem
//
//  Created by Sjmarf on 10/02/2024.
//

import Foundation
import SwiftUI

public extension ApiClient {
    func getCommunity(id: Int) async throws -> Community3 {
        let request = GetCommunityRequest(id: id, name: nil)
        let response = try await perform(request)
        return caches.community3.getModel(api: self, from: response)
    }
    
    func getCommunity(actorId: URL) async throws -> Community3? {
        // search for community
        let request = ResolveObjectRequest(q: actorId.absoluteString)
        
        // if community found, get as Community3--caching performed in call
        if let response = try await perform(request).community {
            // ResolveObject unfortunately only returns a Community2, so we've gotta make another call
            return try await getCommunity(id: response.id)
        }
        return nil
    }
    
    func setupSubscriptionList(
        getFavorites: @escaping () -> Set<Int> = { [] },
        setFavorites: @escaping (Set<Int>) -> Void = { _ in }
    ) -> SubscriptionList {
        if let subscriptions {
            return subscriptions
        } else {
            let new: SubscriptionList = .init(apiClient: self, getFavorites: getFavorites, setFavorites: setFavorites)
            self.subscriptions = new
            return new
        }
        
    }
    
    @discardableResult
    func getSubscriptionList() async throws -> SubscriptionList {
        let subscriptionList = setupSubscriptionList()
        
        let limit = 50
        var page = 1
        var hasMorePages = true
        var communities = [ApiCommunityView]()
        
        repeat {
            let request = ListCommunitiesRequest(type_: .subscribed, sort: nil, page: page, limit: limit, showNsfw: true)
            let response = try await perform(request)
            communities.append(contentsOf: response.communities)
            hasMorePages = response.communities.count >= limit
            page += 1
        } while hasMorePages
            
        let models: Set<Community2> = Set(communities.lazy.map { self.caches.community2.getModel(api: self, from: $0) })
        await subscriptionList.updateCommunities(with: models)
        RunLoop.main.perform {
            self.subscriptions = subscriptionList
        }
        return subscriptionList
    }
    
    @discardableResult
    func subscribeToCommunity(id: Int, subscribe: Bool, semaphore: UInt?) async throws -> Community2 {
        let request = FollowCommunityRequest(communityId: id, follow: subscribe)
        let response = try await perform(request)
        return caches.community2.getModel(api: self, from: response.communityView, semaphore: semaphore)
    }
}
