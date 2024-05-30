//
//  PostStub.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation
import Observation

public struct PostStub: PostStubProviding {
    public static let tierNumber: Int = 0
    public var api: ApiClient
    public let actorId: URL
    
    // DELETEME: public initializer to test upgrading view-side
    public init(api: ApiClient, actorId: URL) {
        self.api = api
        self.actorId = actorId
    }
    
    public static func == (lhs: PostStub, rhs: PostStub) -> Bool {
        lhs.actorId == rhs.actorId
    }
}
