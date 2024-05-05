//
//  UserTier1.swift
//  Mlem
//
//  Created by Sjmarf on 10/02/2024.
//

import SwiftUI

@Observable
public final class Person1: Person1Providing {
    public var api: ApiClient
    public var person1: Person1 { self }
    
    public let actorId: URL
    public let id: Int
    
    public let name: String
    public let creationDate: Date
    
    public var updatedDate: Date? = .distantPast
    public var displayName: String?
    public var description: String?
    public var matrixId: String?
    public var avatar: URL?
    public var banner: URL?
    
    public var deleted: Bool = false
    public var isBot: Bool = false
    
    public var instanceBan: InstanceBanType = .notBanned
    
    // These aren't included in the ApiPerson, and so are set externally by Post2 instead
    public var blocked: Bool = false
    
    internal init(
        api: ApiClient,
        actorId: URL,
        id: Int,
        name: String,
        creationDate: Date,
        updatedDate: Date? = .distantPast,
        displayName: String? = nil,
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
        self.creationDate = creationDate
        self.updatedDate = updatedDate
        self.displayName = displayName
        self.description = description
        self.matrixId = matrixId
        self.avatar = avatar
        self.banner = banner
        self.deleted = deleted
        self.isBot = isBot
        self.instanceBan = instanceBan
        self.blocked = blocked
    }
}
