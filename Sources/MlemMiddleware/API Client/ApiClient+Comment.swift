//
//  ApiClient+Comment.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

public extension ApiClient {
    func getComment(id: Int) async throws -> Comment2 {
        let request = GetCommentRequest(id: id)
        let response = try await perform(request)
        return caches.comment2.getModel(api: self, from: response.commentView)
    }
    
    func getComments(
        postId: Int,
        sort: ApiCommentSortType,
        page: Int,
        maxDepth: Int? = nil,
        limit: Int,
        filter: GetContentFilter? = nil
    ) async throws -> [Comment2] {
        let request = GetCommentsRequest(
            type_: nil,
            sort: sort,
            maxDepth: maxDepth,
            page: page,
            limit: limit,
            communityId: nil,
            communityName: nil,
            postId: postId,
            parentId: nil,
            savedOnly: filter == .saved,
            likedOnly: filter == .upvoted,
            dislikedOnly: filter == .downvoted
        )
        let response = try await perform(request)
        return response.comments.map { caches.comment2.getModel(api: self, from: $0) }
    }
}
