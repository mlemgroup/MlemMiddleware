//
//  ApiCommentView+Extensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-19.
//

import Foundation

extension ApiCommentView: ActorIdentifiable, CacheIdentifiable, Identifiable {
    public var cacheId: Int { id }

    public var actorId: ActorIdentifier { post.actorId }
    public var id: Int { comment.id }
    
    public var resolvedCounts: ApiCommentAggregates {
        if let counts = counts ?? comment.backportedCounts { return counts }
        assertionFailure()
        return .zero
    }
}
