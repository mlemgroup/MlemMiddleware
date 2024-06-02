//
//  AnyPerson.swift
//
//
//  Created by Sjmarf on 30/05/2024.
//

import Foundation

@Observable
public class AnyPerson: Hashable, Upgradable {
    public typealias Base = PersonStubProviding
    public typealias MinimumRenderable = Person1Providing
    public typealias Upgraded = Person3Providing
    
    public var wrappedValue: any PersonStubProviding
    
    public required init(_ wrappedValue: any PersonStubProviding) {
        self.wrappedValue = wrappedValue
    }
}

/// Hashable, Equatable conformance
public extension AnyPerson {
    func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
    
    static func == (lhs: AnyPerson, rhs: AnyPerson) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

/// Upgradable conformance
public extension AnyPerson {    
    func upgrade() async throws {
        let upgradedPerson = try await wrappedValue.upgrade()
        Task { @MainActor in
            self.wrappedValue = upgradedPerson
        }
    }
}
