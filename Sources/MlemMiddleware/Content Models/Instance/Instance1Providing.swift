//
//  Instance1Providing.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public protocol Instance1Providing: ProfileProviding, Identifiable {
    var instance1: Instance1 { get }
    
    var id: Int { get }
    var publicKey: String { get }
    var lastRefreshDate: Date { get }
}

public typealias Instance = Instance1Providing

public extension Instance1Providing {
    var id: Int { instance1.id }
    var name: String { instance1.name }
    var displayName: String { instance1.displayName }
    var description: String? { instance1.description }
    var avatar: URL? { instance1.avatar }
    var banner: URL? { instance1.banner }
    var created: Date { instance1.created }
    var updated: Date? { instance1.updated }
    var publicKey: String { instance1.publicKey }
    var lastRefreshDate: Date { instance1.lastRefreshDate }
    
    var id_: Int? { instance1.id }
    var name_: String? { instance1.name }
    var displayName_: String? { instance1.displayName }
    var description_: String? { instance1.description }
    var avatar_: URL? { instance1.avatar }
    var banner_: URL? { instance1.banner }
    var updated_: Date? { instance1.updated }
    var publicKey_: String? { instance1.publicKey }
    var lastRefreshDate_: Date? { instance1.lastRefreshDate }
}
