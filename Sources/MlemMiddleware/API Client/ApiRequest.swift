//
//  ApiRequest.swift
//  Mlem
//
//  Created by Nicholas Lawson on 06/06/2023.
//

import Foundation

// MARK: - ApiRequest

enum ApiRequestError: Error {
    case authenticationRequired
    case undefinedSession
}

protocol ApiRequest {
    associatedtype Response: Decodable

    var headers: [String: String] { get }
    
    func path(on version: SiteVersion) -> String
    func endpoint(base: URL, version: SiteVersion) throws -> URL
}

extension ApiRequest {
    var headers: [String: String] { defaultHeaders }

    var defaultHeaders: [String: String] {
        ["Content-Type": "application/json"]
    }
}

// MARK: - ApiGetRequest

protocol ApiGetRequest: ApiRequest {
    associatedtype Parameters: Encodable
    var parameters: Parameters? { get }
}

extension ApiRequest {
    func endpoint(base: URL, version: SiteVersion) throws -> URL {
        base
            .appending(path: path(on: version))
    }
}

extension ApiGetRequest {
    func endpoint(base: URL, version: SiteVersion) throws -> URL {
        if let parameters {
            base
                .appending(path: path(on: version))
                .appending(queryItems: try URLQueryItemEncoder.encode(parameters))
        } else {
            base
                .appending(path: path(on: version))
        }
    }
}

// MARK: - ApiRequestBodyProviding

protocol ApiRequestBodyProviding: ApiRequest {
    associatedtype Body: Encodable
    var body: Body? { get }
}

// MARK: - ApiPostRequest

protocol ApiPostRequest: ApiRequestBodyProviding {}

// MARK: - ApiPutRequest

protocol ApiPutRequest: ApiRequestBodyProviding {}
