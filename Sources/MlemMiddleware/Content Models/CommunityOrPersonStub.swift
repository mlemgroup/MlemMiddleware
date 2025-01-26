//
//  CommunityOrAccount.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation
import Observation

public protocol CommunityOrPersonStub: ActorIdentifiable, ContentModel {
    static var identifierPrefix: String { get }
    
    var name: String { get }
}

public extension CommunityOrPersonStub {
    var name: String { actorId.url.lastPathComponent } // TODO Fix this

    var fullName: String { "\(name)@\(host)" }
    
    var fullNameWithPrefix: String { "\(Self.identifierPrefix)\(name)@\(host)" }
}
