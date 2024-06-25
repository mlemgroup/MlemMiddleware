//
//  CommentStubProviding.swift
//  
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

public protocol CommentStubProviding: ContentStub {
    // From Comment1Providing. These are defined as nil in the extension below
    var id_: Int? { get }
    var content_: String? { get }
    var created_: Date? { get }
    var updated_: Date? { get }
    var deleted_: Bool? { get }
    var creatorId_: Int? { get }
    var postId_: Int? { get }
    var parentCommentIds_: [Int]? { get }
    var distinguished_: Bool? { get }
    var languageId_: Int? { get }
    
    // From Comment2Providing. These are defined as nil in the extension below
    var creator_: Person1? { get }
    var community_: Community1? { get }
    var commentCount_: Int? { get }
    var votes_: VotesModel? { get }
    var unreadCommentCount_: Int? { get }
    var saved_: Bool? { get }
    var read_: Bool? { get }
}

public extension CommentStubProviding {
    var id_: Int? { nil }
    var content_: String? { nil }
    var created_: Date? { nil }
    var updated_: Date? { nil }
    var deleted_: Bool? { nil }
    var creatorId_: Int? { nil }
    var postId_: Int? { nil }
    var parentCommentIds_: [Int]? { nil }
    var distinguished_: Bool? { nil }
    var languageId_: Int? { nil }
    
    var creator_: Person1? { nil }
    var community_: Community1? { nil }
    var commentCount_: Int? { nil }
    var votes_: VotesModel? { nil }
    var unreadCommentCount_: Int? { nil }
    var saved_: Bool? { nil }
    var read_: Bool? { nil }
    
    var depth_: Int? { parentCommentIds_?.count }
}

public extension CommentStubProviding {
    func upgrade() async throws -> any Comment {
        try await api.getComment(actorId: actorId)
    }
}
