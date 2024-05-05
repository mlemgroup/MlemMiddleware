//
//  SubscriptionList.swift
//
//
//  Created by Sjmarf on 05/05/2024.
//

import Observation

@Observable
public class SubscriptionList {
    public private(set) var communities: Set<Community2> = .init()
    public private(set) var alphabeticSections: [SubscriptionListSection] = .init()
    
    private var apiClient: ApiClient
    
    internal init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    public func refresh() async throws {
        _ = try await apiClient.getSubscriptionList()
    }
    
    @MainActor
    internal func updateCommunities(with communities: Set<Community2>) {
        self.communities = communities
        let sections: [String: [Community2]] = .init(
            grouping: communities,
            by: \.subscriptionListCategory
        )
        self.alphabeticSections = sections.map {
            .init(
                label: $0.key,
                communities: $0.value.sorted(by: { $0.name < $1.name })
            )
        }.sorted { $0.label < $1.label }
    }
    
    @MainActor
    internal func addCommunity(community: Community2) {
        let category = community.subscriptionListCategory
        if let section = alphabeticSections.first(where: { $0.label == category }) {
            section.add(community: community)
        } else {
            let section = SubscriptionListSection(label: category, communities: [community])
            let index = self.alphabeticSections.insertionIndex { $0.label < category }
            self.alphabeticSections.insert(section, at: index)
        }
    }
    
    @MainActor
    internal func removeCommunity(community: Community2) {
        let category = community.subscriptionListCategory
        if let section = alphabeticSections.first(where: { $0.label == category }) {
            section.remove(community: community)
        }
    }
}

@Observable
public class SubscriptionListSection: Identifiable {
    public private(set) var label: String
    /// Sorted alphabetically by `name`.
    public internal(set) var communities: [Community2]
    
    internal init(label: String, communities: [Community2]) {
        self.label = label
        self.communities = communities
    }
    
    internal func add(community: Community2) {
        let index = communities.insertionIndex { $0.name < community.name }
        communities.insert(community, at: index)
    }
    
    internal func remove(community: Community2) {
        if let index = communities.firstIndex(of: community) {
            communities.remove(at: index)
        }
    }
    
    public var id: String { label }
}

private extension Community1Providing {
    /// Returns the uppercased first letter of the community `name`, stripped of diacritics. If the first letter is a number or symbol, return `"#"` instead.
    var subscriptionListCategory: String {
        let first = String(name.first ?? "#").folding(options: .diacriticInsensitive, locale: .current)
        guard first.first?.isLetter ?? false else { return "#" }
        return first.uppercased()
    }
}

private extension RandomAccessCollection {
    func insertionIndex(for predicate: (Element) -> Bool) -> Index {
        var slice : SubSequence = self[...]

        while !slice.isEmpty {
            let middle = slice.index(slice.startIndex, offsetBy: slice.count / 2)
            if predicate(slice[middle]) {
                slice = slice[index(after: middle)...]
            } else {
                slice = slice[..<middle]
            }
        }
        return slice.startIndex
    }
}
