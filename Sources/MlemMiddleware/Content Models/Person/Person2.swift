//
//  UserCore2.swift
//  Mlem
//
//  Created by Sjmarf on 10/02/2024.
//

import SwiftUI

@Observable
public final class Person2: Person2Providing {
    public var api: ApiClient
    public var person2: Person2 { self }
    
    public let person1: Person1
    
    public var postCount: Int = 0
    public var commentCount: Int = 0
    
    public init(
        api: ApiClient,
        person1: Person1,
        postCount: Int = 0,
        commentCount: Int = 0
    ) {
        self.api = api
        self.person1 = person1
        self.postCount = postCount
        self.commentCount = commentCount
    }
}
