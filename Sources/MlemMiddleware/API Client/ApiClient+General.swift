//
//  ApiClient+General.swift
//
//
//  Created by Sjmarf on 25/06/2024.
//

import Foundation

public extension ApiClient {
    func resolve(actorId: URL) async throws -> ApiResolveObjectResponse {
        let request = ResolveObjectRequest(q: actorId.absoluteString)
        return try await perform(request)
    }
}
