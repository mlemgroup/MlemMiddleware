//
//  CommentStub.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

public struct CommentStub: CommentStubProviding, Hashable {
    public static let tierNumber: Int = 0
    public var api: ApiClient
    public let actorId: URL
    
    public init(api: ApiClient, actorId: URL) {
        self.api = api
        self.actorId = actorId
    }
    
    public func asLocal() -> Self {
        .init(api: .getApiClient(for: actorId.removingPathComponents(), with: nil), actorId: actorId)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(actorId)
    }
    
    public static func == (lhs: CommentStub, rhs: CommentStub) -> Bool {
        lhs.actorId == rhs.actorId
    }
}
