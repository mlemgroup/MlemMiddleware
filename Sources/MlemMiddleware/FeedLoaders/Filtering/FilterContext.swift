//
//  FilterContext.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-12-22.
//

import Foundation

/// Information required to perform filtering (e.g., current user's moderated communities)
public struct FilterContext {
    public let moderatedCommunityIds: Set<URL>
    public let filteredKeywords: Set<String>
    
    public init(moderatedCommunityIds: Set<URL>, filteredKeywords: Set<String>) {
        self.moderatedCommunityIds = moderatedCommunityIds
        self.filteredKeywords = filteredKeywords
    }
    
    static func none() -> FilterContext {
        .init(moderatedCommunityIds: [], filteredKeywords: [])
    }
}