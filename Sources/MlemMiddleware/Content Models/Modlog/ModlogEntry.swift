//
//  ModlogEntry.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-23.
//

import Foundation

public struct ModlogEntry {
    public let created: Date
    public let moderator: Person1?
    public let type: ModlogEntryType
}
