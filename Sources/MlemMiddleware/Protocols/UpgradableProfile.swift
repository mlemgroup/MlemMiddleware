//
//  UpgradableProfile.swift
//
//
//  Created by Eric Andrews on 2024-05-13.
//

import Foundation

public protocol Upgradable {
    associatedtype Upgraded
    
    var upgraded: Upgraded? { get }
    
    func upgrade() async throws
}
