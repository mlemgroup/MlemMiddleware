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
    public var api: ApiClient
    public var instance1: Instance1 { self }
    
    public let actorId: URL
    
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
    
    /// This is set by the ``ApiClient`` when returning a local ``Instance3``.
    /// If it is `false`, it is *not* guaranteed to be non-local.
    public var local: Bool = false
    
    internal init(
        api: ApiClient,
        actorId: URL,
        id: Int,
        instanceId: Int,
        created: Date,
        updated: Date?,
        publicKey: String,
        displayName: String = "",
        description: String? = nil,
        shortDescription: String? = nil,
        avatar: URL? = nil,
        banner: URL? = nil,
        lastRefresh: Date = .distantPast,
        contentWarning: String? = nil
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
    }
}
