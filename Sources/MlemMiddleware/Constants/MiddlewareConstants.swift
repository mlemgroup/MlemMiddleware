//
//  App Constants.swift
//  Mlem
//
//  Created by David Bureš on 03.05.2023.
//

import Foundation
import KeychainAccess

enum MiddlewareConstants {
    static let cacheSize = 500_000_000 // 500MB in bytes
    static let urlCache: URLCache = .init(memoryCapacity: cacheSize, diskCapacity: cacheSize)
    static let infiniteLoadThresholdOffset: Int = -10
}
