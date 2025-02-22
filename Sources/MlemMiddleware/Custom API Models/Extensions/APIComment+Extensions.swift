//
//  ApiComment+Extensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-19.
//

import Foundation

extension ApiComment: ActorIdentifiable, CacheIdentifiable {
    public var cacheId: Int { id }
    
    /// Added in 0.20.0
    var backportedCounts: ApiCommentAggregates? {
        guard let score, let upvotes, let downvotes, let childCount else { return nil }
        return .init(
            id: nil,
            commentId: id,
            score: score,
            upvotes: upvotes,
            downvotes: downvotes,
            published: published,
            childCount: childCount,
            hotRank: nil
        )
    }
}

public extension ApiComment {
    var parentId: Int? {
        let components = path.components(separatedBy: ".")

        guard path != "0", components.count != 2 else {
            return nil
        }

        guard let id = components.dropLast(1).last else {
            return nil
        }

        return Int(id)
    }
}
