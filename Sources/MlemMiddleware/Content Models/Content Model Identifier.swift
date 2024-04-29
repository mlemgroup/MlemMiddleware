//
//  Content Model Identifier.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-08-26.
//

import Foundation
/// Identifier for any content model that ensures two items of different types with the same id (e.g., a message and a reply) remain identifiable from each other.
public struct ContentModelIdentifier: Hashable, Codable {
    public let contentType: ContentType
    public let contentId: Int
}
