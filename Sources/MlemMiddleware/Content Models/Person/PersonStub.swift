//
//  Account.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation
import Observation

public struct PersonStub: PersonStubProviding {
    public static let tierNumber: Int = 0
    public var api: ApiClient
    public let actorId: URL
    
    public static func == (lhs: PersonStub, rhs: PersonStub) -> Bool {
        lhs.actorId == rhs.actorId
    }
}
