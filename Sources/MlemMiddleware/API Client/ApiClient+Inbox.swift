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
    
    func markAllAsRead() async throws {
        let request = MarkAllAsReadRequest()
        try await perform(request)
        for reply in caches.reply1.itemCache.value.values {
            reply.content?.readManager.updateWithReceivedValue(true, semaphore: nil)
        }
        for message in caches.message1.itemCache.value.values {
            message.content?.readManager.updateWithReceivedValue(true, semaphore: nil)
        }
        self.unreadCount?.clear()
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
    
    @discardableResult
    internal func refreshUnreadCount() async throws -> ApiGetUnreadCountResponse {
        let request = GetUnreadCountRequest()
        let response = try await perform(request)
        self.unreadCount?.update(with: response)
        return response
    }
    
    /// Get an ``UnreadCount`` object that continues to be updated by the ``ApiClient`` whenever an inbox item is marked read/unread.
    func getUnreadCount() async throws -> UnreadCount {
        let unreadCount = self.unreadCount ?? .init(api: self)
        let response: ApiGetUnreadCountResponse = try await self.refreshUnreadCount()
        unreadCount.update(with: response)
        self.unreadCount = unreadCount
        return unreadCount
    }
    
    func createMessage(personId: Int, content: String) async throws -> Message2 {
        let request = CreatePrivateMessageRequest(content: content, recipientId: personId)
        let response = try await perform(request)
        return caches.message2.getModel(api: self, from: response.privateMessageView)
    }
    
    @discardableResult
    func editMessage(id: Int, content: String) async throws -> Message2 {
        let request = EditPrivateMessageRequest(privateMessageId: id, content: content)
        let response = try await perform(request)
        return caches.message2.getModel(api: self, from: response.privateMessageView)
    }
    
    func reportMessage(id: Int, reason: String) async throws {
        let request = CreatePrivateMessageReportRequest(privateMessageId: id, reason: reason)
        let response = try await perform(request)
        // TODO: return message report
    }
    
    @discardableResult
    func deleteMessage(id: Int, delete: Bool, semaphore: UInt? = nil) async throws -> Message2 {
        let request = DeletePrivateMessageRequest(privateMessageId: id, deleted: delete)
        let response = try await perform(request)
        return caches.message2.getModel(api: self, from: response.privateMessageView, semaphore: semaphore)
    }
}
