//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-25.
//  

import Foundation

/// An identifier for a Lemmy entity that is unique across all Lemmy instances.
///
/// ## Discussion
///
/// Avoid instantiating`ActorIdentifier`directly, and instead obtain
/// instances by interacting with `ApiClient`.
///
public struct ActorIdentifier: Hashable {
    public let host: String
    public let entityId: EntityIdentifier
    
    /// Create an `ActorIdentifier` from a given URL.
    ///
    /// - Throws: `.invalidHost` If the host could not be extracted from the URL.
    /// - Throws: `.invalidPath` if the URL path did not match any of the supported formats.
    ///
    /// When you use this method, you *must* be sure that the provided URL is the actual ActivityPub
    /// ID for the given entity, and not just any URL pointing to it. As there is no way to ascertain whether
    /// a given URL a valid ActivityPub ID or not without making API calls, this initialiser is kept internal
    /// to prevent misuse.
    ///
    /// This initialiser is capable of parsing the following URL formats:
    /// - `https://example.com`
    /// - `https://example.com/c/name`
    /// - `https://example.com/u/name`
    /// - `https://example.com/post/123`
    /// - `https://example.com/comment/123`
    /// - `https://example.com/private_message/123`
    ///
    internal init(url: URL) throws(ParsingError) {
        guard let host = url.host() else { throw .invalidHost }
        self.host = host
        guard ([0, 1, 3, 4] as Set).contains(url.pathComponents.count) else { throw .invalidPath }
        if url.pathComponents.count <= 1 {
            self.entityId = .instance
        } else {
            switch url.pathComponents[1] {
            case "post":
                guard let postId = Int(url.pathComponents[2]) else { throw .invalidPath }
                self.entityId = .post(id: postId)
            case "comment":
                guard let id = Int(url.pathComponents[2]) else { throw .invalidPath }
                self.entityId = .comment(id: id)
            case "u":
                self.entityId = .person(name: url.pathComponents[2])
            case "c":
                self.entityId = .community(name: url.pathComponents[2])
            case "private_message":
                guard let id = Int(url.pathComponents[2]) else { throw .invalidPath }
                self.entityId = .message(id: id)
            default:
                throw .invalidPath
            }
        }
    }
    
    private init(host: String, entityId: EntityIdentifier) {
        self.host = host
        self.entityId = entityId
    }
    
    public static func instance(host: String) -> Self {
        .init(host: host, entityId: .instance)
    }
    
    public static func person(host: String, name: String) -> Self {
        .init(host: host, entityId: .person(name: name))
    }
    
    @inlinable
    public var type: EntityType { entityId.type }
    
    public var url: URL {
        hostUrl.appending(path: entityId.path)
    }
    
    public var hostUrl: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        return components.url! // This will always succeed
    }
}

extension ActorIdentifier: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let url = URL(string: string) else { throw Self.DecodingError.invalidUrl }
        try self.init(url: url)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(url)
    }
}

extension ActorIdentifier: CustomStringConvertible {
    public var description: String { "https://" + host + entityId.path }
}

extension ActorIdentifier: CustomDebugStringConvertible {
    public var debugDescription: String { "ActorIdentifier(\(description))" }
}

extension ActorIdentifier {
    public enum EntityIdentifier: Hashable {
        case post(id: Int)
        case comment(id: Int)
        case message(id: Int)
        case person(name: String)
        case community(name: String)
        case instance
        
        public var type: EntityType {
            switch self {
            case .post: .post
            case .comment: .comment
            case .message: .message
            case .person: .person
            case .community: .community
            case .instance: .instance
            }
        }
        
        internal var path: String {
            switch self {
            case let .post(id): "/post/\(id)"
            case let .comment(id): "/comment/\(id)"
            case let .message(id): "/private_message/\(id)"
            case let .person(name): "/u/\(name)"
            case let .community(name): "/c/\(name)"
            case .instance: "/"
            }
        }
    }
    
    public enum EntityType {
        case post, comment, message, person, community, instance
    }
    
    public enum ParsingError: Error {
        case invalidHost, invalidPath
    }
    
    public enum DecodingError: Error {
        case invalidUrl
    }
}
