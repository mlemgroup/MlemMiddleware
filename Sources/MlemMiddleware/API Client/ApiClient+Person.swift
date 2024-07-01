//
//  NewApiClient+User.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public extension ApiClient {
    // Returns a raw API type :(
    // Probably OK because it's part of onboarding, which is cursed and bootstrappy
    func login(username: String, password: String, totpToken: String?) async throws -> ApiLoginResponse {
        let request = LoginRequest(
            usernameOrEmail: username,
            password: password,
            totp2faToken: totpToken
        )
        let response = try await perform(request)
        return response
    }
    
    func getPerson(id: Int) async throws -> Person3 {
        let request = GetPersonDetailsRequest(
            personId: id,
            username: nil,
            sort: .new,
            page: 1,
            limit: 1,
            communityId: nil,
            savedOnly: nil
        )
        let response = try await perform(request)
        return caches.person3.getModel(api: self, from: response)
    }
    
    func getPerson(actorId: URL) async throws -> Person2 {
        let request = ResolveObjectRequest(q: actorId.absoluteString)
        do {
            if let response = try await perform(request).person {
                return caches.person2.getModel(api: self, from: response)
            }
        } catch let ApiClientError.response(response, _) where response.couldntFindObject {
            throw ApiClientError.noEntityFound
        }
        throw ApiClientError.noEntityFound
    }
    
    func getPerson(username: String) async throws -> Person3 {
        let request = GetPersonDetailsRequest(
            personId: nil,
            username: username,
            sort: nil,
            page: nil,
            limit: nil,
            communityId: nil,
            savedOnly: nil
        )
        let response = try await perform(request)
        
        return caches.person3.getModel(api: self, from: response)
    }
    
    func getPerson(actorId: URL) async throws -> Person3 {
        let person: Person2 = try await getPerson(actorId: actorId)
        return try await getPerson(id: person.id)
    }
    
    func searchPeople(
        query: String,
        page: Int = 1,
        limit: Int = 20,
        filter: ApiListingType = .all
    ) async throws -> [Person2] {
        let request = SearchRequest(
            q: query,
            communityId: nil,
            communityName: nil,
            creatorId: nil,
            type_: .users,
            sort: .topAll,
            listingType: filter,
            page: page,
            limit: limit
        )
        return try await perform(request).users.map { caches.person2.getModel(api: self, from: $0) }
    }
    
    
    func getContent(authorId id: Int) async throws -> Person3 {
        //    feed: ApiListingType,
        //    sort: ApiSortType,
        //    page: Int,
        //    cursor: String?,
        //    limit: Int,
        //    savedOnly: Bool = false
        let request = GetPersonDetailsRequest(
            personId: id,
            username: nil,
            sort: .new,
            page: 1,
            limit: 1,
            communityId: nil,
            savedOnly: nil
        )
        let response = try await perform(request)
        return caches.person3.getModel(api: self, from: response)
    }
    
    func getMyPerson() async throws -> (person: Person4?, instance: Instance3) {
        let request = GetSiteRequest()
        let response = try await perform(request)
        let instance = caches.instance3.getModel(api: self, from: response)
        
        var person: Person4?
        if let myUser = response.myUser {
            person = caches.person4.getModel(api: self, from: myUser)
        }
        myPerson = person
        myInstance = instance
        return (person: person, instance: instance)
    }
}
