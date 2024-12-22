//
//  FilterContext.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-12-22.
//

import Foundation

/// General app state information required to perform filtering (e.g., current user's moderated communities)
public struct FilterContext {
    public let moderatedCommunityIds: Set<URL>
    
    public init(moderatedCommunityIds: Set<URL>) {
        self.moderatedCommunityIds = moderatedCommunityIds
    }
}
