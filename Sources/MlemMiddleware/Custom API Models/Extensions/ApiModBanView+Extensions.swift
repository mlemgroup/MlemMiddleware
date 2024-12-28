//
//  ApiModBanView+Extensions.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-28.
//  

import Foundation

extension ApiModBanView: ModlogEntryApiBacker {
    var published: Date { modBan.when_ }
    var moderatorId: Int { modBan.id }
    
    @MainActor
    func type(api: ApiClient) -> ModlogEntryType {
        return .banPersonFromInstance(
            person: api.caches.person1.getModel(api: api, from: bannedPerson),
            banned: modBan.banned,
            reason: modBan.reason,
            expires: modBan.expires
        )
    }
}
