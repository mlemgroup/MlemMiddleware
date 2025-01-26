//
//  Account.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation
import Observation

public struct PersonStub: PersonStubProviding, Hashable {
    public static let tierNumber: Int = 0
    public var api: ApiClient
    public let actorId: ActorIdentifier
    
    public init(api: ApiClient, actorId: ActorIdentifier) {
        self.api = api
        self.actorId = actorId
    }
    
    public func asLocal() -> Self {
        .init(api: .getApiClient(for: actorId.hostUrl, with: nil), actorId: actorId)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(actorId)
    }
    
    public static func == (lhs: PersonStub, rhs: PersonStub) -> Bool {
        lhs.actorId == rhs.actorId
    }
}
