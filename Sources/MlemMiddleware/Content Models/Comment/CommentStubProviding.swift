//
//  CommentStubProviding.swift
//  
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

public protocol CommentStubProviding: ActorIdentifiable, ContentModel {
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
    var removed_: Bool? { get }
    var languageId_: Int? { get }
    
    // From Comment2Providing. These are defined as nil in the extension below
    var creator_: Person1? { get }
    var post_: Post1? { get }
    var community_: Community1? { get }
    var votes_: VotesModel? { get }
    var saved_: Bool? { get }
    var creatorIsModerator_: Bool? { get }
    var creatorIsAdmin_: Bool? { get }
    var bannedFromCommunity_: Bool? { get }
    var commentCount_: Int? { get }
    
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
    var removed_: Bool? { nil }
    var languageId_: Int? { nil }
    
    var creator_: Person1? { nil }
    var post_: Post1? { nil }
    var community_: Community1? { nil }
    var votes_: VotesModel? { nil }
    var saved_: Bool? { nil }
    var creatorIsModerator_: Bool? { nil }
    var creatorIsAdmin_: Bool? { nil }
    var bannedFromCommunity_: Bool? { nil }
    var commentCount_: Int? { nil }
    
    var depth_: Int? { parentCommentIds_?.count }
}

public extension CommentStubProviding {
    func upgrade() async throws -> any Comment {
        try await api.getComment(actorId: actorId)
    }
}
