//
//  ContentStub.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

public protocol ContentStub: ActorIdentifiable {
    static var tierNumber: Int { get }
    var api: ApiClient { get }
}

public extension ContentStub {    
     func hash(into hasher: inout Hasher) {
        hasher.combine(actorId)
        hasher.combine(Self.tierNumber)
    }
    
    var apiIsLocal: Bool { api.host == host }
}
