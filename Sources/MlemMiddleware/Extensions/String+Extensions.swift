//
//  String+Extensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-12-10.
//

import Foundation

public extension String {
    func isContainedIn(_ strings: [String]) -> Bool {
        strings.contains { contains($0) }
    }
    
    func isContainedIn(_ strings: Set<String>) -> Bool {
        strings.contains { contains($0) }
    }
    
    /// Returns true if this string contains whole words that are in the given set of strings
    func containsWordsIn(_ strings: Set<String>) -> Bool {
        let words = self.split(separator: " ").map { $0.lowercased() }
        return words.contains { strings.contains($0) }
    }
}
