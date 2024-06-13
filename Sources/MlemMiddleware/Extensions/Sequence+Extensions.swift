//
//  File.swift
//  
//
//  Created by Eric Andrews on 2024-06-12.
//

import Foundation

// from https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/
extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
    
    func asyncCompactMap<T>(
        _ transform: (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            if let newElement = try await transform(element) {
                values.append(newElement)
            }
        }

        return values
    }
}
