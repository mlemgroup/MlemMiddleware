//
//  Post1.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation
import Observation

public struct PostEmbed {
    let title: String?
    let description: String?
    let videoUrl: URL?
}

@Observable
public final class Post1: Post1Providing {
    public static let tierNumber: Int = 1
    public var api: ApiClient
    public var post1: Post1 { self }
    
    public let actorId: URL
    public let id: Int
    
    public var title: String = ""
    public var content: String? = ""
    public var linkUrl: URL?
    public var deleted: Bool = false
    public var embed: PostEmbed?
    public var pinnedCommunity: Bool = false
    public var pinnedInstance: Bool = false
    public var locked: Bool = false
    public var nsfw: Bool = false
    public var removed: Bool = false
    public var thumbnailUrl: URL?
    public let created: Date
    public var updated: Date?
    
    internal init(
        api: ApiClient,
        actorId: URL,
        id: Int,
        created: Date,
        title: String = "",
        content: String? = "",
        linkUrl: URL? = nil,
        deleted: Bool = false,
        embed: PostEmbed? = nil,
        pinnedCommunity: Bool = false,
        pinnedInstance: Bool = false,
        locked: Bool = false,
        nsfw: Bool = false,
        removed: Bool = false,
        thumbnailUrl: URL? = nil,
        updated: Date? = nil
    ) {
        self.api = api
        self.actorId = actorId
        self.id = id
        self.created = created
        self.title = title
        self.content = content
        self.linkUrl = linkUrl
        self.deleted = deleted
        self.embed = embed
        self.pinnedCommunity = pinnedCommunity
        self.pinnedInstance = pinnedInstance
        self.locked = locked
        self.nsfw = nsfw
        self.removed = removed
        self.thumbnailUrl = thumbnailUrl
        self.updated = updated
    }
}
