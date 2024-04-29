//
//  Post1Providing.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

public protocol Post1Providing: PostStubProviding, Identifiable {
    var post1: Post1 { get }
    
    var id: Int { get }
    var title: String { get }
    var content: String? { get }
    var links: [LinkType] { get }
    var linkUrl: URL? { get }
    var deleted: Bool { get }
    var embed: PostEmbed? { get }
    var pinnedCommunity: Bool { get }
    var pinnedInstance: Bool { get }
    var locked: Bool { get }
    var nsfw: Bool { get }
    var created: Date { get }
    var removed: Bool { get }
    var thumbnailUrl: URL? { get }
    var updated: Date? { get }
}

public typealias Post = Post1Providing

public extension Post1Providing {
    var actorId: URL { post1.actorId }
    
    var id: Int { post1.id }
    var title: String { post1.title }
    var content: String? { post1.content }
    var links: [LinkType] { post1.links }
    var linkUrl: URL? { post1.linkUrl }
    var deleted: Bool { post1.deleted }
    var embed: PostEmbed? { post1.embed }
    var pinnedCommunity: Bool { post1.pinnedCommunity }
    var pinnedInstance: Bool { post1.pinnedInstance }
    var locked: Bool { post1.locked }
    var nsfw: Bool { post1.nsfw }
    var created: Date { post1.created }
    var removed: Bool { post1.removed }
    var thumbnailUrl: URL? { post1.thumbnailUrl }
    var updated: Date? { post1.updated }
    
    var id_: Int? { post1.id }
    var title_: String? { post1.title }
    var content_: String? { post1.content }
    var links_: [LinkType]? { post1.links }
    var linkUrl_: URL? { post1.linkUrl }
    var deleted_: Bool? { post1.deleted }
    var embed_: PostEmbed? { post1.embed }
    var pinnedCommunity_: Bool? { post1.pinnedCommunity }
    var pinnedInstance_: Bool? { post1.pinnedInstance }
    var locked_: Bool? { post1.locked }
    var nsfw_: Bool? { post1.nsfw }
    var creationDate_: Date? { post1.created }
    var removed_: Bool? { post1.removed }
    var thumbnailUrl_: URL? { post1.thumbnailUrl }
    var updatedDate_: Date? { post1.updated }
}
