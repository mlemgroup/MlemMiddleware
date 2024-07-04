//
//  Reply+CacheExtensions.swift
//
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation

extension Reply1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with reply: ApiCommentReply) {
        self.read = reply.read
    }
}
