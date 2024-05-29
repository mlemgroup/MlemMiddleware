//
//  PostStub.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

public struct PostStub: PostStubProviding {
    public var api: ApiClient
    public let actorId: URL
    
    public init(api: ApiClient, actorId: URL) {
        self.api = api
        self.actorId = actorId
    }
    
    public static func == (lhs: PostStub, rhs: PostStub) -> Bool {
        lhs.actorId == rhs.actorId
    }
}
