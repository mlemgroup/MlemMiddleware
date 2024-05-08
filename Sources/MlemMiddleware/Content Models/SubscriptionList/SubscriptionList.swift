//
//  SubscriptionList.swift
//
//
//  Created by Sjmarf on 05/05/2024.
//

import SwiftUI

@Observable
public class SubscriptionList {
    /// All subscribed-to communities, including favorited communities.
    public private(set) var communities: Set<Community2> = .init()
    public private(set) var favorites: [Community2] = .init()
    public private(set) var alphabeticSections: [String?: [Community2]] = .init()
    
    private var favoriteIDs: Set<Int> {
        get { getFavorites() }
        set { self.setFavorites(newValue) }
    }
    
    private var getFavorites: () -> Set<Int>
    private var setFavorites: (Set<Int>) -> Void
    
    private var apiClient: ApiClient
    
    internal init(
        apiClient: ApiClient,
        getFavorites: @escaping () -> Set<Int>,
        setFavorites: @escaping (Set<Int>) -> Void) {
        self.apiClient = apiClient
        self.getFavorites = getFavorites
        self.setFavorites = setFavorites
    }
    
    public func refresh() async throws {
        _ = try await apiClient.getSubscriptionList()
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
                    if let index = favorites.firstIndex(of: community) {
                        favorites.remove(at: index)
                    }
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
        if let index = self.favorites.firstIndex(of: community) {
            self.favorites.remove(at: index)
        }
        let category = self.categoryForCommunity(community)
        if let index = self.alphabeticSections[category]?.firstIndex(of: community) {
            self.alphabeticSections[category]?.remove(at: index)
        }
    }
}
