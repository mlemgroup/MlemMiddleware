//
//  PostStubProviding.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

public protocol PostStubProviding: ContentStub {
    // From Post1Providing. These are defined as nil in the extension below
    var id_: Int? { get }
    var title_: String? { get }
    var content_: String? { get }
    var links_: [LinkType]? { get }
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
    var upvoteCount_: Int? { get }
    var downvoteCount_: Int? { get }
    var unreadCommentCount_: Int? { get }
    var saved_: Bool? { get }
    var read_: Bool? { get }
    var myVote_: ScoringOperation? { get }
}

public extension PostStubProviding {
    var id_: Int? { nil }
    var title_: String? { nil }
    var content_: String? { nil }
    var links_: [LinkType]? { nil }
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
    var upvoteCount_: Int? { nil }
    var downvoteCount_: Int? { nil }
    var unreadCommentCount_: Int? { nil }
    var saved_: Bool? { nil }
    var read_: Bool? { nil }
    var myVote_: ScoringOperation? { nil }
}
