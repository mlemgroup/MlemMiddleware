//
//  UpgradableProtocol.swift
//
//
//  Created by Eric Andrews on 2024-05-13.
//

import Foundation

public protocol Upgradable {
    associatedtype Base
    associatedtype MinimumRenderable
    associatedtype Upgraded
    
    var wrappedValue: Base { get }
    
    func upgrade(initialValue: Base?) async throws
    func upgradeFromLocal() async throws
    
    init(_ wrappedValue: Base)
}

public extension Upgradable {
    
    func upgrade() async throws {
        try await self.upgrade(initialValue: nil)
    }
    
    var isRenderable: Bool { wrappedValue is MinimumRenderable }
    
    var isUpgraded: Bool { wrappedValue is Upgraded }
}
