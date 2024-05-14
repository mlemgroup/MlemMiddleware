//
//  UpgradableProtocol.swift
//
//
//  Created by Eric Andrews on 2024-05-13.
//

import Foundation

public protocol Upgradable {
    associatedtype Upgraded
    associatedtype Base
    
    var wrappedValue: Base { get }
    
    func upgrade() async throws
}

public extension Upgradable {
    var isUpgraded: Bool {
        guard let _ = wrappedValue as? Upgraded else {
            return false
        }
        return true
    }
}
