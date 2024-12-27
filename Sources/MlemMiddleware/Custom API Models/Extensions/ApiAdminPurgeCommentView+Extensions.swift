//
//  ApiAdminPurgeCommentView+Extensions.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-26.
//

import Foundation

extension ApiAdminPurgeCommentView: ModlogEntryApiBacker {
    var published: Date { adminPurgeComment.when_ }
    var moderator: ApiPerson? { admin }
    var moderatorId: Int { adminPurgeComment.id }
    
    @MainActor
    func type(api: ApiClient) -> ModlogEntryType {
        .purgeComment(reason: adminPurgeComment.reason)
    }
}
