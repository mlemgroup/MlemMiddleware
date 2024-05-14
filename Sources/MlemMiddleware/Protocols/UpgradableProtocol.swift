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
    
    var value: Base? { get }
    
    func upgrade() async throws -> Upgraded
}
