//
//  InstanceTier1.swift
//  Mlem
//
//  Created by Sjmarf on 09/02/2024.
//

import Foundation
import Observation

@Observable
public final class Instance1: Instance1Providing {
    public static let tierNumber: Int = 1
    public var api: ApiClient
    public var instance1: Instance1 { self }
    
    public let actorId: ActorIdentifier
    
    // For some reason, instances have two different IDs.
    // `instanceId` should be used when blocking the instance.
    public let id: Int
    public let instanceId: Int
    
    public let created: Date
    public let updated: Date?
    public let publicKey: String
    
    public var displayName: String = ""
    public var description: String?
    public var shortDescription: String?
    public var avatar: URL?
    public var banner: URL?
    public var lastRefresh: Date = .distantPast
    public var contentWarning: String?
    
    /// If this is `false`, The instance is *not* guaranteed to be non-local, particularly for locally running instances.
    public var local: Bool = false
    
    // This is set externally when the instance is loaded
    internal var blockedManager: StateManager<Bool>
    public var blocked: Bool { blockedManager.wrappedValue }
    
    internal init(
        api: ApiClient,
        actorId: ActorIdentifier,
        id: Int,
        instanceId: Int,
        created: Date,
        updated: Date?,
        publicKey: String,
        displayName: String,
        description: String?,
        shortDescription: String?,
        avatar: URL?,
        banner: URL?,
        lastRefresh: Date,
        contentWarning: String?,
        blocked: Bool?
    ) {
        self.api = api
        self.actorId = actorId
        self.id = id
        self.instanceId = instanceId
        self.created = created
        self.updated = updated
        self.publicKey = publicKey
        self.displayName = displayName
        self.description = description
        self.shortDescription = shortDescription
        self.avatar = avatar
        self.banner = banner
        self.lastRefresh = lastRefresh
        self.contentWarning = contentWarning
        self.local = actorId.url == api.baseUrl
        self.blockedManager = .init(
            wrappedValue: blocked ?? api.blocks?.instances.keys.contains(actorId) ?? false
        )
        self.blockedManager.onSet = { newValue, type, _ in
            if type != .receive {
                if newValue {
                    api.blocks?.instances[actorId] = instanceId
                } else {
                    api.blocks?.instances.removeValue(forKey: actorId)
                }
            }
        }
    }
}
