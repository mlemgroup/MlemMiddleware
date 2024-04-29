//
//  UserStub.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import SwiftUI

public struct PersonStub: PersonStubProviding {
    public var api: ApiClient
    public let actorId: URL
    
    public static func == (lhs: PersonStub, rhs: PersonStub) -> Bool {
        lhs.actorId == rhs.actorId
    }
}
