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
        return await caches.comment2.getModel(api: self, from: response.commentView)
    }
    
    func getComment(actorId: URL) async throws -> Comment2 {
        let request = ResolveObjectRequest(q: actorId.absoluteString)
        do {
            if let response = try await perform(request).comment {
                return await caches.comment2.getModel(api: self, from: response)
            }
        } catch let ApiClientError.response(response, _) where response.couldntFindObject {
            throw ApiClientError.noEntityFound
        }
        throw ApiClientError.noEntityFound
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
            type_: .all,
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
        return await caches.comment2.getModels(api: self, from: response.comments)
    }
    
    func getComments(
        parentId: Int,
        sort: ApiCommentSortType,
        page: Int,
        maxDepth: Int? = nil,
        limit: Int,
        filter: GetContentFilter? = nil
    ) async throws -> [Comment2] {
        let request = GetCommentsRequest(
            type_: .all,
            sort: sort,
            maxDepth: maxDepth,
            page: page,
            limit: limit,
            communityId: nil,
            communityName: nil,
            postId: nil,
            parentId: parentId,
            savedOnly: filter == .saved,
            likedOnly: filter == .upvoted,
            dislikedOnly: filter == .downvoted
        )
        let response = try await perform(request)
        return await caches.comment2.getModels(api: self, from: response.comments)
    }
    
    @discardableResult
    func voteOnComment(id: Int, score: ScoringOperation, semaphore: UInt? = nil) async throws -> Comment2 {
        let request = LikeCommentRequest(commentId: id, score: score.rawValue)
        let response = try await perform(request)
        return await caches.comment2.getModel(api: self, from: response.commentView, semaphore: semaphore)
    }
    
    @discardableResult
    func saveComment(id: Int, save: Bool, semaphore: UInt? = nil) async throws -> Comment2 {
        let request = SaveCommentRequest(commentId: id, save: save)
        let response = try await perform(request)
        return await caches.comment2.getModel(api: self, from: response.commentView, semaphore: semaphore)
    }
    
    @discardableResult
    func deleteComment(id: Int, delete: Bool, semaphore: UInt? = nil) async throws -> Comment2 {
        let request = DeleteCommentRequest(commentId: id, deleted: delete)
        let response = try await perform(request)
        return await caches.comment2.getModel(api: self, from: response.commentView, semaphore: semaphore)
    }
    
    @discardableResult
    func editComment(
        id: Int,
        content: String,
        languageId: Int?
    ) async throws -> Comment2 {
        let request = EditCommentRequest(
            commentId: id,
            content: content,
            languageId: languageId,
            formId: nil
        )
        let response = try await perform(request)
        return await caches.comment2.getModel(api: self, from: response.commentView)
    }
    
    // There's also a `replyToPost` method in `ApiClient+Post` for creating a comment on a post
    func replyToComment(postId: Int, parentId: Int?, content: String, languageId: Int? = nil) async throws -> Comment2 {
        let request = CreateCommentRequest(
            content: content,
            postId: postId,
            parentId: parentId,
            languageId: languageId,
            formId: nil
        )
        let response = try await perform(request)
        let comment = await caches.comment2.getModel(api: self, from: response.commentView)
        comment.getCachedInboxReply()?.setKnownReadState(newValue: true)
        return comment
    }
    
    @discardableResult
    func reportComment(id: Int, reason: String) async throws -> Report {
        let request = CreateCommentReportRequest(commentId: id, reason: reason)
        let response = try await perform(request)
        return await caches.report.getModel(api: self, from: response.commentReportView)
    }
    
    func purgeComment(id: Int, reason: String?) async throws {
        let request = PurgeCommentRequest(commentId: id, reason: reason)
        let response = try await perform(request)
        guard response.success else { throw ApiClientError.unsuccessful }
        caches.comment1.retrieveModel(cacheId: id)?.purged = true
    }
    
    @discardableResult
    func removeComment(
        id: Int,
        remove: Bool,
        reason: String?,
        semaphore: UInt? = nil
    ) async throws -> Comment2 {
        let request = RemoveCommentRequest(commentId: id, removed: remove, reason: reason)
        let response = try await perform(request)
        return await caches.comment2.getModel(api: self, from: response.commentView, semaphore: semaphore)
    }
}
