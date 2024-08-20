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
    public private(set) var instanceSections: [String?: [Community2]] = .init()
    
    public internal(set) var hasLoaded: Bool = false
    
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
    
    private func alphabeticCategoryForCommunity(_ community: Community2) -> String? {
        let first = String(community.name.first ?? "#").folding(options: .diacriticInsensitive, locale: .current)
        guard first.first?.isLetter ?? false else { return nil }
        return first.uppercased()
    }
    
    @MainActor
    internal func updateCommunities(with communities: Set<Community2>) {
        self.communities = communities
        
        // Alphabetical
        
        var alphabeticSections: [String?: [Community2]] = .init()
        
        let alphabeticSectionsGrouping: [String?: [Community2]] = .init(
            grouping: communities,
            by: { alphabeticCategoryForCommunity($0) }
        )
        for section in alphabeticSectionsGrouping {
            alphabeticSections[section.key] = section.value.sorted(by: { $0.name < $1.name })
        }
        
        self.alphabeticSections = alphabeticSections
        
        // Instance
        
        var otherSection = [Community2]()
        let instanceSectionsGrouping: [String?: [Community2]] = .init(grouping: communities, by: \.host)
        var instanceSections: [String?: [Community2]] = .init()
        
        for section in instanceSectionsGrouping {
            if section.value.count == 1, let community = section.value.first {
                otherSection.append(community)
            } else {
                instanceSections[section.key] = section.value.sorted(by: { $0.name < $1.name })
            }
        }
        if !otherSection.isEmpty {
            instanceSections[nil] = otherSection.sorted(by: { $0.name < $1.name })
        }
        self.instanceSections = instanceSections
        
        self.favorites = communities.filter { favoriteIDs.contains($0.id) }
    }
    
    func updateCommunitySubscription(community: Community2) {
        guard hasLoaded else { return }
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
        } else if self.communities.contains(community) {
            self.removeCommunity(community: community)
        }
    }
        
    private func addCommunity(community: Community2) {
        self.communities.insert(community)
        
        let alphabeticCategory = self.alphabeticCategoryForCommunity(community)
        if self.alphabeticSections.keys.contains(alphabeticCategory) {
            self.alphabeticSections[alphabeticCategory]?.sortedInsert(community) { $0.name < community.name }
        } else {
            self.alphabeticSections[alphabeticCategory] = [community]
        }
        
        let hostCategoryExists = instanceSections.keys.contains(community.host)
        let hostExists: Bool = (
            hostCategoryExists || instanceSections[nil, default: []].contains(where: { $0.host == community.host })
        )
        
        if hostExists {
            if hostCategoryExists {
                instanceSections[community.host]?.sortedInsert(community) { $0.name < community.name }
            } else {
                if let otherCommunity = instanceSections[nil]?.removeFirst(where: { $0.host == community.host }) {
                    instanceSections[community.host] = [community, otherCommunity].sorted { $0.name < $1.name }
                } else {
                    instanceSections[nil, default: []].append(community)
                }
            }
        }
    }
    
    private func removeCommunity(community: Community2) {
        self.communities.remove(community)
        self.favoriteIDs.remove(community.id)
        favorites.removeFirst { $0 === community }
        let category = self.alphabeticCategoryForCommunity(community)
        self.alphabeticSections[category]?.removeFirst { $0 === community }
        if self.alphabeticSections[category]?.isEmpty ?? false {
            self.alphabeticSections.removeValue(forKey: category)
        }
        
        if var items = instanceSections[community.host] {
            switch items.count {
            case 1:
                instanceSections.removeValue(forKey: community.host)
            case 2:
                items.removeFirst { $0 === community }
                instanceSections[nil, default: []].sortedInsert(items[0], for: { $0.name < community.name })
                instanceSections.removeValue(forKey: community.host)
            default:
                instanceSections[community.host]?.removeFirst { $0 === community }
            }
        } else {
            self.alphabeticSections[nil]?.removeFirst { $0 === community }
        }
    }
}
