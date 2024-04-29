//
//  ContentStub.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

public protocol ContentStub: ActorIdentifiable {
    var api: ApiClient { get }
}

public extension ContentStub {
    var host: String? { actorId.host() }
}
