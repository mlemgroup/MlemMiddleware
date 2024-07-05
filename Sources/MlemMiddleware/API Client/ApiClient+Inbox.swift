//
//  ApiClient+Inbox.swift
//
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation

public extension ApiClient {
    func getReplies(
        sort: ApiCommentSortType = .new,
        page: Int,
        limit: Int,
        unreadOnly: Bool = false
    ) async throws -> [Reply2] {
        let request = GetRepliesRequest(sort: sort, page: page, limit: limit, unreadOnly: unreadOnly)
        let response = try await perform(request)
        return response.replies.map { caches.reply2.getModel(api: self, from: $0) }
    }
    
    func getMentions(
        sort: ApiCommentSortType = .new,
        page: Int,
        limit: Int,
        unreadOnly: Bool = false
    ) async throws -> [Reply2] {
        let request = GetPersonMentionsRequest(sort: sort, page: page, limit: limit, unreadOnly: unreadOnly)
        let response = try await perform(request)
        return response.mentions.map { caches.reply2.getModel(api: self, from: $0) }
    }
    
    func getMessages(
        creatorId: Int? = nil,
        page: Int,
        limit: Int,
        unreadOnly: Bool = false
    ) async throws -> [Message2] {
        let request = GetPrivateMessagesRequest(unreadOnly: unreadOnly, page: page, limit: limit, creatorId: creatorId)
        let response = try await perform(request)
        return response.privateMessages.map { caches.message2.getModel(api: self, from: $0) }
    }
    
    @discardableResult
    func markReplyAsRead(
        id: Int,
        read: Bool = true,
        semaphore: UInt? = nil
    ) async throws -> Reply2 {
        let request = MarkCommentReplyAsReadRequest(commentReplyId: id, read: read)
        let response = try await perform(request)
        return caches.reply2.getModel(api: self, from: response.commentReplyView, semaphore: semaphore)
    }
    
    @discardableResult
    func markMentionAsRead(
        id: Int,
        read: Bool = true,
        semaphore: UInt? = nil
    ) async throws -> Reply2 {
        let request = MarkPersonMentionAsReadRequest(personMentionId: id, read: read)
        let response = try await perform(request)
        return caches.reply2.getModel(api: self, from: response.personMentionView, semaphore: semaphore)
    }
    
    @discardableResult
    func markMessageAsRead(
        id: Int,
        read: Bool = true,
        semaphore: UInt? = nil
    ) async throws -> Message2 {
        let request = MarkPrivateMessageAsReadRequest(privateMessageId: id, read: read)
        let response = try await perform(request)
        return caches.message2.getModel(api: self, from: response.privateMessageView, semaphore: semaphore)
    }
}
