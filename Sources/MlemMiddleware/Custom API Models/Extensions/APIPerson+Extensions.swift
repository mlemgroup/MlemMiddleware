//
//  ApiPerson+Extensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-19.
//

import Foundation

extension ApiPerson: ActorIdentifiable, CacheIdentifiable, Identifiable {
    public var cacheId: Int { id }
    
    /// Added in 0.20.0
    var backportedCounts: ApiPersonAggregates? {
        guard let postCount, let commentCount else { return nil }
        return .init(
            id: nil,
            personId: id,
            postCount: postCount,
            postScore: nil,
            commentCount: commentCount,
            commentScore: nil
        )
    }
}
