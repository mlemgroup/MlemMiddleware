//
//  NewSavedUser.swift
//  Mlem
//
//  Created by Sjmarf on 10/02/2024.
//

import Foundation
import SwiftUI
import KeychainAccess

let keychain: Keychain = .init(service: "com.hanners.Mlem-keychain")

enum UserError: Error {
    case noUserInResponse
    case unauthenticated
}

@Observable
public final class UserStub: UserProviding, Codable {
    public var api: ApiClient
    
    public var stub: UserStub { self }
    
    public let id: Int
    public let name: String
    public var actorId: URL
    
    public var nickname: String?
    public var cachedSiteVersion: SiteVersion?
    public var avatarUrl: URL?
    public var lastLoggedIn: Date?
    
    enum CodingKeys: String, CodingKey {
        // These key names don't match the identifiers of their corresponding properties - this is because these key names must match the property names used in SavedAccount pre-1.3 in order to maintain compatibility
        case id, username, storedNickname, instanceLink, siteVersion, avatarUrl, lastUsed
    }
    
    enum DecodingError: Error {
        case noTokenInKeychain, cannotRemoveExtraneousPathComponents
    }
    
    init(
        api: ApiClient,
        id: Int,
        name: String,
        actorId: URL,
        nickname: String? = nil,
        cachedSiteVersion: SiteVersion? = nil,
        avatarUrl: URL? = nil,
        lastLoggedIn: Date? = nil
    ) {
        self.api = api
        self.id = id
        self.name = name
        self.actorId = actorId
        self.nickname = nickname
        self.cachedSiteVersion = cachedSiteVersion
        self.avatarUrl = avatarUrl
        self.lastLoggedIn = lastLoggedIn
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // copy simple values
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .username)
        self.nickname = try values.decode(String?.self, forKey: .storedNickname)
        self.cachedSiteVersion = try values.decode(SiteVersion?.self, forKey: .siteVersion)
        self.avatarUrl = try values.decode(URL?.self, forKey: .avatarUrl)
        self.lastLoggedIn = try values.decode(Date?.self, forKey: .lastUsed)

        // parse instance link
        let instanceLink = try values.decode(URL.self, forKey: .instanceLink)
        // Remove the "api/v3" path that we attached to the instanceLink pre-2.0
        var components = URLComponents(url: instanceLink, resolvingAgainstBaseURL: false)!
        components.path = ""
        guard let instanceLink = components.url else { throw DecodingError.cannotRemoveExtraneousPathComponents }
        
        // parse actor id
        let actorId = parseActorId(instanceLink: instanceLink, name: name)
        self.actorId = actorId
        
        // retrive token and initialize ApiClient
        guard let token = keychain[getKeychainId(actorId: actorId)] ?? keychain[getKeychainId(id: id)] else {
            throw DecodingError.noTokenInKeychain
        }
        self.api = ApiClient.getApiClient(for: instanceLink, with: token)
    }
    
    public func encode(to encoder: Encoder) throws {
        saveTokenToKeychain()
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .username)
        try container.encode(nickname, forKey: .storedNickname)
        try container.encode(cachedSiteVersion, forKey: .siteVersion)
        try container.encode(avatarUrl, forKey: .avatarUrl)
        try container.encode(lastLoggedIn, forKey: .lastUsed)
        try container.encode(api.baseUrl, forKey: .instanceLink)
    }
    
    public var keychainId: String {
        getKeychainId(actorId: actorId)
    }
    
    public func updateToken(_ newToken: String) {
        self.api.updateToken(newToken)
    }
    
    func saveTokenToKeychain() {
        keychain[getKeychainId(actorId: actorId)] = api.token
    }
    
    public func deleteTokenFromKeychain() {
        try? keychain.remove(getKeychainId(actorId: actorId))
        try? keychain.remove(getKeychainId(id: id))
    }
}

private func getKeychainId(actorId: URL) -> String {
    "\(actorId.absoluteString)_accessToken"
}

private func getKeychainId(id: Int) -> String {
    "\(id)_accessToken"
}

func parseActorId(instanceLink: URL, name: String) -> URL {
    var actorComponents = URLComponents(url: instanceLink, resolvingAgainstBaseURL: false)!
    actorComponents.path = "/u/\(name)"
    return actorComponents.url!
}
