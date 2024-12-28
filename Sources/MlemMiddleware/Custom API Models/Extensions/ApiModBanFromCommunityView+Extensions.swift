//
//  ApiModBanFromCommunityView+Extensions.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-28.
//  

import Foundation

extension ApiModBanFromCommunityView: ModlogEntryApiBacker {
    var published: Date { modBanFromCommunity.when_ }
    var moderatorId: Int { modBanFromCommunity.id }
    
    @MainActor
    func type(api: ApiClient) -> ModlogEntryType {
        return .banPersonFromCommunity(
            person: api.caches.person1.getModel(api: api, from: bannedPerson),
            community: api.caches.community1.getModel(api: api, from: community),
            banned: modBanFromCommunity.banned,
            reason: modBanFromCommunity.reason,
            expires: modBanFromCommunity.expires
        )
    }
}
