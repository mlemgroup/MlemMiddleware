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
    
    public let id: Int
    public let name: String
    public let creationDate: Date
    public let updatedDate: Date?
    public let publicKey: String
    
    public var displayName: String = ""
    public var description: String?
    public var avatar: URL?
    public var banner: URL?
    public var lastRefreshDate: Date = .distantPast
    
    public init(
        api: ApiClient,
        id: Int,
        creationDate: Date,
        updatedDate: Date?,
        publicKey: String,
        name: String,
        displayName: String = "",
        description: String? = nil,
        avatar: URL? = nil,
        banner: URL? = nil,
        lastRefreshDate: Date = .distantPast
    ) {
        self.api = api
        self.id = id
        self.creationDate = creationDate
        self.updatedDate = updatedDate
        self.publicKey = publicKey
        self.name = name
        self.displayName = displayName
        self.description = description
        self.avatar = avatar
        self.banner = banner
        self.lastRefreshDate = lastRefreshDate
    }
}
