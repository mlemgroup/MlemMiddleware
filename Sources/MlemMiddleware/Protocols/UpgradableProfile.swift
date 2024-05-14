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
    
    func upgrade() async throws -> Upgraded
}

public class AnyUpgradable<T: Upgradable> {
    typealias Upgraded = T.Upgraded
    
    public let wrappedValue: any Upgradable
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}
