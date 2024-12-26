//
//  ModlogEntryApiBacker.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-25.
//

import Foundation

internal protocol ModlogEntryApiBacker {
    var moderator: ApiPerson? { get }
    var published: Date { get }
    
    @MainActor
    func type(api: ApiClient) -> ModlogEntryType
}
