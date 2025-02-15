//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-02.
//  

import Foundation

#if DEBUG
public extension ApiClient {
    static let mock: MockApiClient = .init()
}

public class MockApiClient: ApiClient {
    var communities: [Community2]?
    
    public init(communities: [Community2]? = nil) {
        self.communities = communities
        super.init(
            url: URL(string: "https://example.com/")!,
            username: nil,
            permissions: .all
        )
    }
    
    override func perform<Request: ApiRequest>(_ request: Request, requiresToken: Bool = true) async throws -> Request.Response {
        if let request = request as? SearchRequest, let communities {
            return ApiSearchResponse(
                type_: .all,
                comments: [],
                posts: [],
                communities: communities.map(\.apiCommunityView),
                users: []
            ) as! Request.Response
        }
        
        throw ApiClientError.insufficientPermissions
    }
}
#endif
