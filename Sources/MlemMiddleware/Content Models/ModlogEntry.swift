//
//  ModlogEntry.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-23.
//

import Foundation

public struct ModlogEntry {
    public let created: Date
    public let moderator: Person1?
}

public enum ModlogEntryType {
    case removePost(
        _ post: Post1,
        community: Community1,
        removed: Bool,
        reason: String?
    )
    case lockPost(
        _ post: Post1,
        community: Community1,
        locked: Bool
    )
    case pinPost(
        _ post: Post1,
        community: Community1,
        pinned: Bool,
        type: ApiPostFeatureType
    )
    
    case removeComment(
        _ comment: Comment2,
        creator: Person1,
        post: Post1,
        community: Community1,
        removed: Bool,
        reason: String?
    )
    
    case removeCommunity(
        _ community: Community1,
        removed: Bool,
        reason: String?
    )
    case purgeCommunity(reason: String?)
    case hideCommunity(_ community: Community1, hidden: Bool)
    case transferCommunityOwnership(
        person: Person1,
        community: Community1
    )
    
    case updatePersonModeratorStatus(
        person: Person1,
        community: Community1,
        appointed: Bool
    )
    case updatePersonAdminStatus(
        person: Person1,
        appointed: Bool
    )
    case banPersonFromCommunity(
        person: Person1,
        community: Community1,
        banned: Bool,
        reason: String?,
        expires: Date
    )
    case banPersonFromInstance(
        person: Person1,
        banned: Bool,
        reason: String?,
        expires: Date
    )
    case purgePerson(reason: String?)
}
