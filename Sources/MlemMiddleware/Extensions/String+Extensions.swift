//
//  String+Extensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-12-10.
//

import Foundation

public extension String {
    func contains(_ strings: [String]) -> Bool {
        strings.contains { contains($0) }
    }
    
    func isContainedIn(_ strings: Set<String>) -> Bool {
        strings.contains { contains($0) }
    }
}
