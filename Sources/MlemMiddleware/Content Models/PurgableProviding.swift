//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-10-27.
//

import Foundation

public protocol PurgableProviding: ContentIdentifiable {
    func purge(reason: String?) async throws
}
