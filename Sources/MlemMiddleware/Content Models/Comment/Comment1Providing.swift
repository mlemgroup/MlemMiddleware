//
//  Comment1Providing.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation
import Observation

public protocol Comment1Providing:
        CommentStubProviding,
        ContentIdentifiable,
        Interactable1Providing,
        DeletableProviding,
        ReportableProviding,
        SelectableContentProviding,
        FeedLoadable where FilterType == CommentFilterType {
    var comment1: Comment1 { get }
    var id: Int { get }
    var content: String { get }
    var created: Date { get }
    var updated: Date? { get }
    var deleted: Bool { get }
    var creatorId: Int { get }
    var postId: Int { get }
    var parentCommentIds: [Int] { get }
    var distinguished: Bool { get }
    var removed: Bool { get }
    var languageId: Int { get }
}

public typealias Comment = Comment1Providing

public extension Comment1Providing {
    static var modelTypeId: ContentType { .comment }
    
    var actorId: URL { comment1.actorId }
    
    var id: Int { comment1.id }
    var content: String { comment1.content }
    var created: Date { comment1.created }
    var updated: Date? { comment1.updated }
    var deleted: Bool { comment1.deleted }
    var creatorId: Int { comment1.creatorId }
    var postId: Int { comment1.postId }
    var parentCommentIds: [Int] { comment1.parentCommentIds }
    var distinguished: Bool { comment1.distinguished }
    var removed: Bool { comment1.distinguished }
    var languageId: Int { comment1.languageId }
    
    var id_: Int? { comment1.id }
    var content_: String? { comment1.content }
    var created_: Date? { comment1.created }
    var updated_: Date? { comment1.updated }
    var deleted_: Bool? { comment1.deleted }
    var creatorId_: Int? { comment1.creatorId }
    var postId_: Int? { comment1.postId }
    var parentCommentIds_: [Int]? { comment1.parentCommentIds }
    var distinguished_: Bool? { comment1.distinguished }
    var removed_: Bool? { comment1.distinguished }
    var languageId_: Int? { comment1.languageId }
}

// SelectableContentProviding conformance
public extension Comment1Providing {
    var selectableContent: String? { content }
}

// FeedLoadable conformance
public extension Comment1Providing {
    func sortVal(sortType: FeedLoaderSort.SortType) -> FeedLoaderSort {
        switch sortType {
        case .new:
            return .new(created)
        }
    }
}

public extension Comment1Providing {
    private var deletedManager: StateManager<Bool> { comment1.deletedManager }

    var depth: Int { parentCommentIds.count }
    
    func upgrade() async throws -> any Comment {
        try await api.getComment(id: id)
    }
    
    func reply(content: String, languageId: Int? = nil) async throws -> Comment2 {
        try await api.replyToComment(postId: postId, parentId: id, content: content, languageId: languageId)
    }
    
    func report(reason: String) async throws {
        try await api.reportComment(id: id, reason: reason)
    }
    
    @discardableResult
    func updateDeleted(_ newValue: Bool) -> Task<StateUpdateResult, Never> {
        deletedManager.performRequest(expectedResult: newValue) { semaphore in
            try await self.api.deleteComment(id: self.id, delete: newValue, semaphore: semaphore)
        }
    }
}
