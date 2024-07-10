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
    
    func getBlocked() async throws -> (people: [Person1], communities: [Community1], instances: [Instance1]) {
        let request = GetSiteRequest()
        let response = try await perform(request)
        
        guard let myUser = response.myUser else { return ([], [], []) }
        
        return (
            people: myUser.personBlocks.map { caches.person1.getModel(api: self, from: $0.target) },
            communities: myUser.communityBlocks.map { caches.community1.getModel(api: self, from: $0.community) },
            instances: myUser.instanceBlocks?.compactMap {
                if let site = $0.site {
                    return caches.instance1.getModel(api: self, from: site)
                }
                return nil
            } ?? []
        )
    }
}
