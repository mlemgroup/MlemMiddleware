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
        
        print(request)
        
        let response = try await perform(request)
        print(response)
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
    
    func getPerson(actorId: URL) async throws -> Person3? {
        let request = ResolveObjectRequest(q: actorId.absoluteString)
        
        // if community found, get as Person3--caching performed in call
        if let response = try await perform(request).person {

            // ResolveObject unfortunately only returns a Person2, so we've gotta make another call
            return try await getPerson(id: response.id)
        }
        return nil
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
