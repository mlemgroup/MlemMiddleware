//
//  Post1.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation
import Observation

public struct PostEmbed: Equatable {
    public let title: String?
    public let description: String?
    public let videoUrl: URL?
}

@Observable
public final class Post1: Post1Providing {
    public static let tierNumber: Int = 1
    public var api: ApiClient
    public var post1: Post1 { self }
    
    public let actorId: URL
    public let id: Int
    public let creatorId: Int
    public let communityId: Int
    
    public var title: String
    
    // We can't name this 'body' because @Observable uses that property name already
    public var content: String?
    public var linkUrl: URL?
    public var loopsMediaUrl: URL?
    public var embed: PostEmbed?
    public var nsfw: Bool
    public var thumbnailUrl: URL?
    public let created: Date
    public var updated: Date?
    public var languageId: Int
    public var altText: String?
    
    public var purged: Bool = false
    
    public var lockedManager: StateManager<Bool>
    public var locked: Bool { lockedManager.wrappedValue }
    public var verifiedLocked: Bool { lockedManager.verifiedValue }
    
    public var pinnedCommunityManager: StateManager<Bool>
    public var pinnedCommunity: Bool { pinnedCommunityManager.wrappedValue }
    
    public var pinnedInstanceManager: StateManager<Bool>
    public var pinnedInstance: Bool { pinnedInstanceManager.wrappedValue }
    
    internal var deletedManager: StateManager<Bool>
    public var deleted: Bool { deletedManager.wrappedValue }
    
    public var removedManager: StateManager<Bool>
    public var removed: Bool { removedManager.wrappedValue }
    
    internal init(
        api: ApiClient,
        actorId: URL,
        id: Int,
        creatorId: Int,
        communityId: Int,
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
        updated: Date? = nil,
        languageId: Int,
        altText: String?
    ) {
        self.api = api
        self.actorId = actorId
        self.id = id
        self.creatorId = creatorId
        self.communityId = communityId
        self.created = created
        self.title = title
        self.content = content
        self.linkUrl = linkUrl
        self.deletedManager = .init(wrappedValue: deleted)
        self.embed = embed
        self.pinnedCommunityManager = .init(wrappedValue: pinnedCommunity)
        self.pinnedInstanceManager = .init(wrappedValue: pinnedInstance)
        self.lockedManager = .init(wrappedValue: locked)
        self.nsfw = nsfw
        self.removedManager = .init(wrappedValue: removed)
        self.thumbnailUrl = thumbnailUrl
        self.updated = updated
        self.languageId = languageId
        self.altText = altText
    }
}
