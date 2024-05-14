//
//  PostStub.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import SwiftUI

public struct PostStub: PostStubProviding {
    public var api: ApiClient
    public let actorId: URL

    public static func == (lhs: PostStub, rhs: PostStub) -> Bool {
        lhs.actorId == rhs.actorId
    }
}
