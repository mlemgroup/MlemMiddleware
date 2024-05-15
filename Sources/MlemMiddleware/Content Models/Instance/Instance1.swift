//
//  InstanceTier1.swift
//  Mlem
//
//  Created by Sjmarf on 09/02/2024.
//

import Foundation
import SwiftUI

@Observable
public final class Instance1: Instance1Providing {
    public var api: ApiClient
    public var instance1: Instance1 { self }
    
    public let actorId: URL
    public let id: Int
    public let created: Date
    public let updated: Date?
    public let publicKey: String
    
    public var displayName: String = ""
    public var description: String?
    public var avatar: URL?
    public var banner: URL?
    public var lastRefreshDate: Date = .distantPast
    
    internal init(
        api: ApiClient,
        actorId: URL,
        id: Int,
        created: Date,
        updated: Date?,
        publicKey: String,
        displayName: String = "",
        description: String? = nil,
        avatar: URL? = nil,
        banner: URL? = nil,
        lastRefreshDate: Date = .distantPast
    ) {
        self.api = api
        self.actorId = actorId
        self.id = id
        self.created = created
        self.updated = updated
        self.publicKey = publicKey
        self.displayName = displayName
        self.description = description
        self.avatar = avatar
        self.banner = banner
        self.lastRefreshDate = lastRefreshDate
    }
}
