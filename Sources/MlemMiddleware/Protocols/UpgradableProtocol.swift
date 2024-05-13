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
    
    /// Upgraded type, if this entity is fully upgraded
    var upgraded: Upgraded? { get }
    
    /// Upgrade this item and return the upgraded type
    func upgrade() async throws -> Upgraded
}
