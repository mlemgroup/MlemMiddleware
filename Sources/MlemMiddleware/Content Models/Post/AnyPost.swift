//
//  AnyPost.swift
//
//
//  Created by Eric Andrews on 2024-05-13.
//

import Foundation

@Observable
public class AnyPost: Hashable, Upgradable {
    public typealias Base = PostStubProviding
    public typealias MinimumRenderable = Post1Providing
    public typealias Upgraded = Post2Providing
    
    public var wrappedValue: any PostStubProviding
    
    public required init(_ wrappedValue: any PostStubProviding) {
        self.wrappedValue = wrappedValue
    }
    
}

/// Hashable, Equatable conformance
public extension AnyPost {
    func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
    
    static func == (lhs: AnyPost, rhs: AnyPost) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

/// Upgradable conformance
public extension AnyPost {
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
            initialValue: PostStub(
                api: .getApiClient(for: wrappedValue.actorId.removingPathComponents(), with: nil),
                actorId: wrappedValue.actorId
            )
        )
    }
}
