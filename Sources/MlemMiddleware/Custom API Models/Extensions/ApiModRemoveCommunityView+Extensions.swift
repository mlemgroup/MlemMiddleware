//
//  ApiModRemoveCommunityView+Extensions.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-26.
//

import Foundation

extension ApiModRemoveCommunityView: ModlogEntryApiBacker {
    var published: Date { self.modRemoveCommunity.when_ }
    
    @MainActor
    func type(api: ApiClient) -> ModlogEntryType {
        .removeCommunity(
            api.caches.community1.getModel(api: api, from: community),
            removed: modRemoveCommunity.removed,
            reason: modRemoveCommunity.reason
        )
    }
}
