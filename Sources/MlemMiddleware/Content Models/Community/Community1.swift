//
//  CommunityTier1.swift
//  Mlem
//
//  Created by Sjmarf on 03/02/2024.
//

import Foundation
import Observation

@Observable
public final class Community1: Community1Providing {
    public static let tierNumber: Int = 1
    public var community1: Community1 { self }
    public var api: ApiClient

    public let actorId: URL
    public let id: Int
    
    public let name: String
    public let created: Date
    
    public var updated: Date? = .distantPast
    public var displayName: String = ""
    public var description: String?
    public var removed: Bool = false
    public var deleted: Bool = false
    public var nsfw: Bool = false
    public var avatar: URL?
    public var banner: URL?
    public var hidden: Bool = false
    public var onlyModeratorsCanPost: Bool = false
    
    // This isn't included in ApiCommunity - it's included in ApiCommunityView, but defined here to maintain similarity with Person models. Person models don't have the `blocked` property defined in any of the Api types, annoyingly. Instead, certain parent models such as ApiPostView contain the value.
    internal var blockedManager: StateManager<Bool>
    public var blocked: Bool { blockedManager.wrappedValue }
  
    internal init(
        api: ApiClient,
        actorId: URL,
        id: Int,
        name: String,
        created: Date,
        updated: Date? = .distantPast,
        displayName: String = "",
        description: String? = nil,
        removed: Bool = false,
        deleted: Bool = false,
        nsfw: Bool = false,
        avatar: URL? = nil,
        banner: URL? = nil,
        hidden: Bool = false,
        onlyModeratorsCanPost: Bool = false,
        blocked: Bool? = nil
    ) {
        self.api = api
        self.actorId = actorId
        self.id = id
        self.name = name
        self.created = created
        self.updated = updated
        self.displayName = displayName
        self.description = description
        self.removed = removed
        self.deleted = deleted
        self.nsfw = nsfw
        self.avatar = avatar
        self.banner = banner
        self.hidden = hidden
        self.onlyModeratorsCanPost = onlyModeratorsCanPost
        self.blockedManager = .init(wrappedValue: blocked ?? api.blocks?.communities.keys.contains(actorId) ?? false)
        self.blockedManager.onSet = { newValue, type, _ in
            if type != .receive {
                if newValue {
                    api.blocks?.communities[actorId] = id
                } else {
                    api.blocks?.communities.removeValue(forKey: actorId)
                }
            }
        }
    }
}
