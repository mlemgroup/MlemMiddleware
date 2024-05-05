//
//  CommunityTier1.swift
//  Mlem
//
//  Created by Sjmarf on 03/02/2024.
//

import Observation
import SwiftUI

@Observable
public final class Community1: Community1Providing {
    public var community1: Community1 { self }
    public var api: ApiClient

    public let actorId: URL
    public let id: Int
    
    public let name: String
    public let creationDate: Date
    
    public var updatedDate: Date? = .distantPast
    public var displayName: String = ""
    public var description: String?
    public var removed: Bool = false
    public var deleted: Bool = false
    public var nsfw: Bool = false
    public var avatar: URL?
    public var banner: URL?
    public var hidden: Bool = false
    public var onlyModeratorsCanPost: Bool = false
    
    // This isn't included in the ApiCommunity - it's included in ApiCommunityView, but defined here to maintain similarity with User models. User models don't have the `blocked` property defined in any of the Api types, annoyingly, so we instead request a list of all blocked users and cache the result in `MyUserStub`.
    public var blocked: Bool = false
  
    internal init(
        api: ApiClient,
        actorId: URL,
        id: Int,
        name: String,
        creationDate: Date,
        updatedDate: Date? = .distantPast,
        displayName: String = "",
        description: String? = nil,
        removed: Bool = false,
        deleted: Bool = false,
        nsfw: Bool = false,
        avatar: URL? = nil,
        banner: URL? = nil,
        hidden: Bool = false,
        onlyModeratorsCanPost: Bool = false,
        blocked: Bool = false
    ) {
        self.api = api
        self.actorId = actorId
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.updatedDate = updatedDate
        self.displayName = displayName
        self.description = description
        self.removed = removed
        self.deleted = deleted
        self.nsfw = nsfw
        self.avatar = avatar
        self.banner = banner
        self.hidden = hidden
        self.onlyModeratorsCanPost = onlyModeratorsCanPost
        self.blocked = blocked
    }
}
