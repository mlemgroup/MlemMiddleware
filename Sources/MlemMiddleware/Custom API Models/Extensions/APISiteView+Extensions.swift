//
//  ApiSiteView+Extensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-19.
//

import Foundation

extension ApiSiteView: CacheIdentifiable, ActorIdentifiable, Identifiable {
    public var cacheId: Int { actorId.hashValue }
    
    public var actorId: URL { site.actorId }
    public var id: Int { site.id }
}
