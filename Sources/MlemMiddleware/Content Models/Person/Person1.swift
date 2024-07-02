//
//  UserTier1.swift
//  Mlem
//
//  Created by Sjmarf on 10/02/2024.
//

import Foundation
import Observation

@Observable
public final class Person1: Person1Providing {
    public static let tierNumber: Int = 1
    public var api: ApiClient
    public var person1: Person1 { self }
    
    public let actorId: URL
    public let id: Int
    
    public let name: String
    public let created: Date
    
    public var updated: Date? = .distantPast
    public var displayName: String
    public var description: String?
    public var matrixId: String?
    public var avatar: URL?
    public var banner: URL?
    
    public var deleted: Bool = false
    public var isBot: Bool = false
    
    public var instanceBan: InstanceBanType = .notBanned
    
    // This isn't included in the ApiPerson, and so is set externally by Post2 instead
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
        matrixId: String? = nil,
        avatar: URL? = nil,
        banner: URL? = nil,
        deleted: Bool = false,
        isBot: Bool = false,
        instanceBan: InstanceBanType = .notBanned,
        blocked: Bool = false
    ) {
        self.api = api
        self.actorId = actorId
        self.id = id
        self.name = name
        self.created = created
        self.updated = updated
        self.displayName = displayName
        self.description = description
        self.matrixId = matrixId
        self.avatar = avatar
        self.banner = banner
        self.deleted = deleted
        self.isBot = isBot
        self.instanceBan = instanceBan
        self.blockedManager = .init(wrappedValue: blocked)
    }
}
