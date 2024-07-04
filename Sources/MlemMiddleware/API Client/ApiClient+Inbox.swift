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
        return []
    }
}
