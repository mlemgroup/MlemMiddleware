//
//  SubscriptionList.swift
//
//
//  Created by Sjmarf on 05/05/2024.
//

import Observation

@Observable
public class SubscriptionList {
    /// All subscribed-to communities, including favorited communities.
    public private(set) var communities: Set<Community2> = .init()
    public private(set) var favorites: [Community2] = .init()
    public private(set) var alphabeticSections: [String?: [Community2]] = .init()
    
    internal var favoriteIDs: Set<Int> {
        get { getFavorites() }
        set { self.setFavorites(newValue) }
    }
    
    private var getFavorites: () -> Set<Int>
    private var setFavorites: (Set<Int>) -> Void
    
    private var api: ApiClient
    
    internal init(
        apiClient: ApiClient,
        getFavorites: @escaping () -> Set<Int>,
        setFavorites: @escaping (Set<Int>) -> Void) {
        self.api = apiClient
        self.getFavorites = getFavorites
        self.setFavorites = setFavorites
    }
    
    public func refresh() async throws {
        _ = try await api.getSubscriptionList()
    }
    
    public func isFavorited(_ community: any Community) -> Bool {
        favoriteIDs.contains(community.id)
    }
    
    private func categoryForCommunity(_ community: Community2) -> String? {
        let first = String(community.name.first ?? "#").folding(options: .diacriticInsensitive, locale: .current)
        guard first.first?.isLetter ?? false else { return nil }
        return first.uppercased()
    }
    
    @MainActor
    internal func updateCommunities(with communities: Set<Community2>) {
        self.communities = communities
        let sections: [String?: [Community2]] = .init(
            grouping: communities,
            by: { categoryForCommunity($0) }
        )
        for section in sections {
            self.alphabeticSections[section.key] = section.value.sorted(by: { $0.name < $1.name })
        }
    }
    
    func updateCommunitySubscription(community: Community2) {
        if community.subscribed {
            if !self.communities.contains(community) {
                self.addCommunity(community: community)
            }
            if isFavorited(community) != community.shouldBeFavorited {
                if community.shouldBeFavorited {
                    self.favoriteIDs.insert(community.id)
                    self.favorites.sortedInsert(community) { $0.name < community.name }
                } else {
                    self.favoriteIDs.remove(community.id)
                    favorites.removeFirst { $0 === community }
                }
            }
        } else {
            self.removeCommunity(community: community)
        }
    }
        
    private func addCommunity(community: Community2) {
        let category = self.categoryForCommunity(community)
        self.communities.insert(community)
        if self.alphabeticSections.keys.contains(category) {
            self.alphabeticSections[category]?.sortedInsert(community) { $0.name < community.name }
        } else {
            self.alphabeticSections[category] = [community]
        }
    }
    
    private func removeCommunity(community: Community2) {
        self.communities.remove(community)
        self.favoriteIDs.remove(community.id)
        favorites.removeFirst { $0 === community }
        let category = self.categoryForCommunity(community)
        self.alphabeticSections[category]?.removeFirst { $0 === community }
    }
}
