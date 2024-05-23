//
//  Profile1Providing.swift
//
//
//  Created by Sjmarf on 20/05/2024.
//

import Foundation

public protocol Profile1Providing: ActorIdentifiable {
    var name: String { get }
    var avatar: URL? { get }
}
