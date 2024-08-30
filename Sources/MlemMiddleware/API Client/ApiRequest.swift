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
    var path: String { get }
    var headers: [String: String] { get }
    
    func endpoint(base: URL) -> URL
}

protocol ApiResponsiveRequest: ApiRequest {
    associatedtype Response: Decodable
}

extension ApiRequest {
    var headers: [String: String] { defaultHeaders }

    var defaultHeaders: [String: String] {
        ["Content-Type": "application/json"]
    }
}

// MARK: - ApiGetRequest

protocol ApiGetRequest: ApiResponsiveRequest {
    var queryItems: [URLQueryItem] { get }
}

extension ApiRequest {
    func endpoint(base: URL) -> URL {
        base
            .appending(path: path)
    }
}

extension ApiGetRequest {
    func endpoint(base: URL) -> URL {
        base
            .appending(path: path)
            .appending(queryItems: queryItems.filter { $0.value != nil })
    }
}

// MARK: - ApiRequestBodyProviding

protocol ApiRequestBodyProviding: ApiRequest {
    associatedtype Body: Encodable
    var body: Body? { get }
}

// MARK: - ApiPostRequest

protocol ApiPostRequest: ApiResponsiveRequest, ApiRequestBodyProviding {}

// MARK: - ApiPutRequest

protocol ApiPutRequest: ApiResponsiveRequest, ApiRequestBodyProviding {}

protocol ApiDeleteRequest: ApiRequest {}
