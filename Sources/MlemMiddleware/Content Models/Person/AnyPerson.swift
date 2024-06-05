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
    func upgrade(initialValue: (any Base)? = nil) async throws {
        var lastValue = initialValue ?? self.wrappedValue
        while !isUpgraded {
            lastValue = try await lastValue.upgrade()
            let task = Task { @MainActor [lastValue] in
                self.wrappedValue = lastValue
            }
            _ = await task.value
        }
    }
    
    func upgradeFromLocal() async throws {
        try await upgrade(
            initialValue: PersonStub(
                api: .getApiClient(for: wrappedValue.actorId.removingPathComponents(), with: nil),
                actorId: wrappedValue.actorId
            )
        )
    }
}
