//
//  Person4Providing.swift
//
//
//  Created by Sjmarf on 20/05/2024.
//

import Foundation

public protocol Person4Providing: Person3Providing {
    var person4: Person4 { get }
}

public extension Person4Providing {
    var person3: Person3 { person4.person3 }
}
