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
    func upgrade() async throws {
        let upgradedPost = try await wrappedValue.upgrade()
        Task { @MainActor in
            self.wrappedValue = upgradedPost
        }
    }
}
