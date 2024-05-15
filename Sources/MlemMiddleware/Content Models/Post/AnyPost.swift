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
    
    public var post: any PostStubProviding
    
    public init(post: any PostStubProviding) {
        self.post = post
    }
    
}

/// Hashable, Equatable conformance
public extension AnyPost {
    func hash(into hasher: inout Hasher) {
        hasher.combine(post)
    }
    
    static func == (lhs: AnyPost, rhs: AnyPost) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

/// Upgradable conformance
public extension AnyPost {
    var wrappedValue: any PostStubProviding { post }
    
    func upgrade() async throws {
        let upgradedPost = try await post.upgrade()
        Task { @MainActor in
            self.post = upgradedPost
        }
    }
}
