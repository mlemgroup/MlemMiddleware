//
//  NewApiClient+Requests.swift
//  Mlem
//
//  Created by Sjmarf on 10/02/2024.
//

import Foundation

public extension ApiClient {
    func getCommunity(id: Int) async throws -> Community3 {
        let request = GetCommunityRequest(id: id, name: nil)
        let response = try await perform(request)
        return caches.community3.getModel(api: self, from: response)
    }
    
    func getCommunity(actorId: URL) async throws -> Community2 {
        let request = ResolveObjectRequest(q: actorId.absoluteString)
        do {
            if let response = try await perform(request).community {
                return caches.community2.getModel(api: self, from: response)
            }
        } catch let ApiClientError.response(response, _) where response.couldntFindObject {
            throw ApiClientError.noEntityFound
        }
        throw ApiClientError.noEntityFound
    }
    
    func getCommunity(actorId: URL) async throws -> Community3 {
        let comm: Community2 = try await getCommunity(actorId: actorId)
        return try await getCommunity(id: comm.id)
    }
    
    func searchCommunities(
        query: String,
        page: Int = 1,
        limit: Int = 20,
        filter: ApiListingType = .all,
        sort: ApiSortType = .topAll
    ) async throws -> [Community2] {
        let request = SearchRequest(
            q: query,
            communityId: nil,
            communityName: nil,
            creatorId: nil,
            type_: .communities,
            sort: sort,
            listingType: filter,
            page: page,
            limit: limit
        )
        return try await perform(request).communities.map { caches.community2.getModel(api: self, from: $0) }
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
        subscriptionList.hasLoaded = true
        return subscriptionList
    }
    
    @discardableResult
    func subscribeToCommunity(id: Int, subscribe: Bool, semaphore: UInt?) async throws -> Community2 {
        let request = FollowCommunityRequest(communityId: id, follow: subscribe)
        let response = try await perform(request)
        return caches.community2.getModel(api: self, from: response.communityView, semaphore: semaphore)
    }
    
    @discardableResult
    func blockCommunity(id: Int, block: Bool, semaphore: UInt? = nil) async throws -> Community2 {
        let request = BlockCommunityRequest(communityId: id, block: block)
        let response = try await perform(request)
        let person = caches.community2.getModel(api: self, from: response.communityView, semaphore: semaphore)
        return person
    }
    
    @discardableResult
    func removeCommunity(
        id: Int,
        remove: Bool,
        reason: String?,
        semaphore: UInt? = nil
    ) async throws -> Community2 {
        let request = RemoveCommunityRequest(communityId: id, removed: remove, reason: reason, expires: nil)
        let response = try await perform(request)
        return await caches.community2.getModel(api: self, from: response.communityView, semaphore: semaphore)
    }
    
    func purgeCommunity(id: Int, reason: String?) async throws {
        let request = PurgeCommunityRequest(communityId: id, reason: reason)
        let response = try await perform(request)
        guard response.success else { throw ApiClientError.unsuccessful }
        caches.community1.retrieveModel(cacheId: id)?.purged = true
    }
}
