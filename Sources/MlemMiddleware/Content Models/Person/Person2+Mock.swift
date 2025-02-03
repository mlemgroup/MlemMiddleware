//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-02.
//  

import Foundation

#if DEBUG
public extension Person2 {
    static func mock(
        api: ApiClient = .mock,
        person1: Person1,
        postCount: Int,
        commentCount: Int,
        isAdmin: Bool
    ) -> Person2 {
        assert(api === person1.api)
        return Person2(
            api: api,
            person1: person1,
            postCount: postCount,
            commentCount: commentCount,
            isAdmin: isAdmin
        )
    }
}
#endif
