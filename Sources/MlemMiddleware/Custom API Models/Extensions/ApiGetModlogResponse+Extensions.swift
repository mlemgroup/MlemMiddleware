//
//  ApiGetModlogResponse+Extensions.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-25.
//

import Foundation

extension ApiGetModlogResponse {
    var allEntries: [any ModlogEntryApiBacker] {
        // Compiler didn't like it when I used `a + b + c + d`
        var output: [any ModlogEntryApiBacker] = []
        output += removedPosts
        output += lockedPosts
        output += featuredPosts
        output += adminPurgedPosts
        output += removedComments
        output += adminPurgedComments
        output += removedCommunities
        output += adminPurgedCommunities
        output += hiddenCommunities
        output += transferredToCommunity
        output += addedToCommunity
        return output
    }
}
