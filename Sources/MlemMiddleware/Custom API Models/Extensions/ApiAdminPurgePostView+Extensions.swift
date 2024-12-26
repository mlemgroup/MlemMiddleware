//
//  ApiAdminPurgePostView+Extensions.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-26.
//

import Foundation

extension ApiAdminPurgePostView: ModlogEntryApiBacker {
    var published: Date { self.adminPurgePost.when_ }
    var moderator: ApiPerson? { self.admin }
    
    @MainActor
    func type(api: ApiClient) -> ModlogEntryType {
        .purgePost(reason: self.adminPurgePost.reason)
    }
}
