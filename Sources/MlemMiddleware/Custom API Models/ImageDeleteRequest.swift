//
//  File.swift
//  
//
//  Created by Sjmarf on 26/08/2024.
//

import Foundation

struct ImageDeleteRequest: ApiDeleteRequest {
    typealias Response = ImageDeleteResponse
    
    public let path: String
    public let queryItems: [URLQueryItem]
    
    init(
        file: String,
        deleteToken: String
    ) {
        self.path = "delete/\(deleteToken)/\(file)"
        self.queryItems = []
    }
}

struct ImageDeleteResponse: Decodable {}
