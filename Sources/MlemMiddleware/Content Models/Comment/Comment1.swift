//
//  Comment1.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation
import Observation

@Observable
public final class Comment1: Comment1Providing {
    public static let tierNumber: Int = 1
    public var api: ApiClient
    public var comment1: Comment1 { self }
    
    public let actorId: URL
    public let id: Int
    public let parentCommentIds: [Int]
    public let creatorId: Int
    public let postId: Int
    
    public var content: String
    public var removed: Bool
    public var created: Date
    public var updated: Date?
    public var distinguished: Bool
    public var languageId: Int
    
    internal var deletedManager: StateManager<Bool>
    public var deleted: Bool { deletedManager.wrappedValue }
    
    // ApiBackedCacheIdentifiable conformance
    internal var apiTypeHash: Int = 0
    
    internal init(
        api: ApiClient,
        actorId: URL,
        id: Int,
        content: String,
        removed: Bool,
        created: Date,
        updated: Date?,
        deleted: Bool,
        creatorId: Int,
        postId: Int,
        parentCommentIds: [Int],
        distinguished: Bool,
        languageId: Int
    ) {
        self.api = api
        self.actorId = actorId
        self.id = id
        self.content = content
        self.removed = removed
        self.created = created
        self.updated = updated
        self.deletedManager = .init(wrappedValue: deleted)
        self.creatorId = creatorId
        self.postId = postId
        self.parentCommentIds = parentCommentIds
        self.distinguished = distinguished
        self.languageId = languageId
    }
}
