//
//  ApiClient+General.swift
//
//
//  Created by Sjmarf on 25/06/2024.
//

import Foundation

public extension ApiClient {
    var isAdmin: Bool {
        myInstance?.administrators.contains(where: { $0.id == myPerson?.id }) ?? false
    }
    
    // Returns a raw API type :(
    // Probably OK because it's part of onboarding, which is cursed and bootstrappy
    func logIn(username: String, password: String, totpToken: String?) async throws -> ApiLoginResponse {
        let request = LoginRequest(
            usernameOrEmail: username,
            password: password,
            totp2faToken: totpToken
        )
        return try await perform(request)
    }
    
    func signUp(
        username: String,
        password: String,
        confirmPassword: String,
        showNsfw: Bool,
        email: String?,
        captcha: Captcha?,
        captchaAnswer: String?,
        applicationQuestionResponse: String?
    ) async throws -> ApiLoginResponse {
        let request = RegisterRequest(
            username: username,
            password: password,
            passwordVerify: confirmPassword,
            showNsfw: showNsfw,
            email: email,
            captchaUuid: captcha?.id.uuidString,
            captchaAnswer: captchaAnswer,
            honeypot: nil,
            answer: applicationQuestionResponse
        )
        return try await perform(request)
    }
    
    func getCaptcha() async throws -> Captcha {
        let request = GetCaptchaRequest()
        let response = try await perform(request)
        
        guard let info = response.ok,
              let uuid = UUID(uuidString: info.uuid),
              let data = Data(base64Encoded: info.png)
        else { throw ApiClientError.unsuccessful }
        
        return .init(id: uuid, imageData: data)
    }
    
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
