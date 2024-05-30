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
    
    public var person: any PersonStubProviding
    
    public init(person: any PersonStubProviding) {
        self.person = person
    }
    
}

/// Hashable, Equatable conformance
public extension AnyPerson {
    func hash(into hasher: inout Hasher) {
        hasher.combine(person)
        hasher.combine(type(of: person).tierNumber)
    }
    
    static func == (lhs: AnyPerson, rhs: AnyPerson) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

/// Upgradable conformance
public extension AnyPerson {
    var wrappedValue: any PersonStubProviding { person }
    
    func upgrade() async throws {
        let upgradedPerson = try await person.upgrade()
        Task { @MainActor in
            self.person = upgradedPerson
        }
    }
}
