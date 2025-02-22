//
//  ApiSiteView+Extensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-19.
//

import Foundation

extension ApiSiteView: CacheIdentifiable, ActorIdentifiable, Identifiable {
    public var cacheId: Int { id }
    
    public var actorId: ActorIdentifier { site.actorId }
    public var id: Int { site.id }
    
    public var resolvedCounts: ApiSiteAggregates {
        if let counts = counts ?? localSite.backportedCounts { return counts }
        assertionFailure()
        return .zero
    }
}
