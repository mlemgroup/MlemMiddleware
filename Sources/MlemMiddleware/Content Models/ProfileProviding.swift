//
//  ProfileProviding.swift
//
//
//  Created by Sjmarf on 08/05/2024.
//

import Foundation

public protocol ProfileProviding {
    var name: String { get }
    var displayName: String { get }
    var description: String? { get }
    var avatar: URL? { get }
    var banner: URL? { get }
    var created: Date { get }
    var updated: Date? { get }
}
