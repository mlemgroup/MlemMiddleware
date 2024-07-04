//
//  ReplyCaches.swift
//  
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation

class Reply1Cache: ApiTypeBackedCache<Reply1, ApiCommentReply> {
    override func performModelTranslation(api: ApiClient, from apiType: ApiCommentReply) -> Reply1 {
        .init(
            api: api,
            id: apiType.id,
            recipientId: apiType.recipientId,
            commentId: apiType.commentId,
            created: apiType.published,
            read: apiType.read
        )
    }
    
    override func updateModel(_ item: Reply1, with apiType: ApiCommentReply, semaphore: UInt? = nil) {
        item.update(with: apiType)
    }
}
