//
//  UpgradableProtocol.swift
//
//
//  Created by Eric Andrews on 2024-05-13.
//

import Foundation

/// Protocol for types that can be upgraded
public protocol Upgradable {
    /// The canonical upgraded type for the entity conforming to this protocol
    associatedtype Upgraded
    
    /// Whether this item is upgraded or not
    /// Ideally Upgraded would be flagged as a protocol and we could do this generically with a "if let _ = self as? Upgraded" but I can't find a nice way to do that [ Eric 2024-05.13 ]
    func isUpgraded() -> Bool
    
    /// Upgrade this item and return the upgraded type
    func upgrade() async throws -> Upgraded
}
