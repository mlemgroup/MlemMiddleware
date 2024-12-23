//
//  FilterContext.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-12-22.
//

import Foundation

/// Information required to perform filtering
public struct FilterContext {
    public let isAdmin: Bool
    public let moderatedCommunityIds: Set<URL>
    public let filteredKeywords: Set<String>
    
    public init(isAdmin: Bool, moderatedCommunityIds: Set<URL>, filteredKeywords: Set<String>) {
        self.isAdmin = isAdmin
        self.moderatedCommunityIds = moderatedCommunityIds
        self.filteredKeywords = filteredKeywords
    }
    
    static func none() -> FilterContext {
        .init(isAdmin: true, moderatedCommunityIds: [], filteredKeywords: [])
    }
}
