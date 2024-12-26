//
//  ApiAdminPurgeCommentView+Extensions.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-26.
//

import Foundation

extension ApiAdminPurgeCommentView: ModlogEntryApiBacker {
    var published: Date { self.adminPurgeComment.when_ }
    var moderator: ApiPerson? { self.admin }
    
    @MainActor
    func type(api: ApiClient) -> ModlogEntryType {
        .purgeComment(reason: self.adminPurgeComment.reason)
    }
}
