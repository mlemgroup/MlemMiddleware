//
//  ApiClient+General.swift
//
//
//  Created by Sjmarf on 25/06/2024.
//

import Foundation

public extension ApiClient {
    func resolve(actorId: URL) async throws -> (any ActorIdentifiable)? {
        let request = ResolveObjectRequest(q: actorId.absoluteString)
        let response = try await perform(request)
        if let post = response.post {
            return caches.post2.getModel(api: self, from: post)
        }
        if let comment = response.comment {
            return caches.comment2.getModel(api: self, from: comment)
        }
        if let person = response.person {
            return caches.person2.getModel(api: self, from: person)
        }
        if let community = response.community {
            return caches.community2.getModel(api: self, from: community)
        }
        throw ApiClientError.noEntityFound
    }
}
