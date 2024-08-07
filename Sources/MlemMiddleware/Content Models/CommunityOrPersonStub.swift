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
    var name: String { actorId.lastPathComponent }

    var fullName: String? {
        guard let host else { return nil }
        return "\(name)@\(host)"
    }
    
    var fullNameWithPrefix: String? {
        guard let host else { return nil }
        return "\(Self.identifierPrefix)\(name)@\(host)"
    }
}
