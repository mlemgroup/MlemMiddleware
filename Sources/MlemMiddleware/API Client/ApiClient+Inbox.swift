//
//  ApiClient+Inbox.swift
//
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation

public extension ApiClient {
    func getInboxReplies(
        sort: ApiCommentSortType = .new,
        page: Int,
        limit: Int,
        unreadOnly: Bool = false
    ) async throws -> [Reply2] {
        let request = GetRepliesRequest(sort: sort, page: page, limit: limit, unreadOnly: unreadOnly)
        let response = try await perform(request)
        return response.replies.map { caches.reply2.getModel(api: self, from: $0) }
    }
    
    func getInboxMentions(
        sort: ApiCommentSortType = .new,
        page: Int,
        limit: Int,
        unreadOnly: Bool = false
    ) async throws -> [Reply2] {
        let request = GetPersonMentionsRequest(sort: sort, page: page, limit: limit, unreadOnly: unreadOnly)
        let response = try await perform(request)
        return response.mentions.map { caches.reply2.getModel(api: self, from: $0) }
    }
}
