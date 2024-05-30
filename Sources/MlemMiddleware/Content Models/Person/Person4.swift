//
//  Person4.swift
//
//
//  Created by Sjmarf on 20/05/2024.
//

import Observation

@Observable
public final class Person4: Person4Providing {
    public static let tierNumber: Int = 4
    public var api: ApiClient
    public var person4: Person4 { self }

    public let person3: Person3
    
    internal init(
        api: ApiClient,
        person3: Person3
    ) {
        self.api = api
        self.person3 = person3
    }
    
    func upgrade() async throws -> Person3 { person3 }
}
