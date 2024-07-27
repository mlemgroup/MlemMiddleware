//
//  PostStubProviding.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

public protocol PostStubProviding: ActorIdentifiable, ContentModel {
    // From Post1Providing. These are defined as nil in the extension below
    var id_: Int? { get }
    var creatorId_: Int? { get }
    var communityId_: Int? { get }
    var title_: String? { get }
    var content_: String? { get }
    var linkUrl_: URL? { get }
    var deleted_: Bool? { get }
    var embed_: PostEmbed? { get }
    var pinnedCommunity_: Bool? { get }
    var pinnedInstance_: Bool? { get }
    var locked_: Bool? { get }
    var nsfw_: Bool? { get }
    var created_: Date? { get }
    var removed_: Bool? { get }
    var thumbnailUrl_: URL? { get }
    var updated_: Date? { get }
    
    // From Post2Providing. These are defined as nil in the extension below
    var creator_: Person1? { get }
    var community_: Community1? { get }
    var commentCount_: Int? { get }
    var votes_: VotesModel? { get }
    var unreadCommentCount_: Int? { get }
    var saved_: Bool? { get }
    var read_: Bool? { get }
    var hidden_: Bool? { get }
    
    func upgrade() async throws -> any Post
}

public extension PostStubProviding {
    var id_: Int? { nil }
    var creatorId_: Int? { nil }
    var communityId_: Int? { nil }
    var title_: String? { nil }
    var content_: String? { nil }
    var linkUrl_: URL? { nil }
    var deleted_: Bool? { nil }
    var embed_: PostEmbed? { nil }
    var pinnedCommunity_: Bool? { nil }
    var pinnedInstance_: Bool? { nil }
    var locked_: Bool? { nil }
    var nsfw_: Bool? { nil }
    var created_: Date? { nil }
    var removed_: Bool? { nil }
    var thumbnailUrl_: URL? { nil }
    var updated_: Date? { nil }
    
    var creator_: Person1? { nil }
    var community_: Community1? { nil }
    var commentCount_: Int? { nil }
    var votes_: VotesModel? { nil }
    var unreadCommentCount_: Int? { nil }
    var saved_: Bool? { nil }
    var read_: Bool? { nil }
    var hidden_: Bool? { nil }
}

public extension PostStubProviding {
    func upgrade() async throws -> any Post {
        try await api.getPost(actorId: actorId)
    }
}
