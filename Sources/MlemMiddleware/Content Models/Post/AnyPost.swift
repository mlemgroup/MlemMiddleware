//
//  AnyPost.swift
//
//
//  Created by Eric Andrews on 2024-05-13.
//

import Foundation

public struct AnyPost: Hashable {
    public let post: any PostStubProviding
    
    public init(post: any PostStubProviding) {
        self.post = post
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(post)
    }
    
    public static func == (lhs: AnyPost, rhs: AnyPost) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
