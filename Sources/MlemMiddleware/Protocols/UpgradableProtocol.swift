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
    
    func upgrade() async throws
    
    init(_ wrappedValue: Base)
}

public extension Upgradable {
    var isRenderable: Bool {
        guard let _ = wrappedValue as? MinimumRenderable else {
            return false
        }
        return true
    }
    
    var isUpgraded: Bool {
        guard let _ = wrappedValue as? Upgraded else {
            return false
        }
        return true
    }
}
