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
    public init() {
        super.init(
            url: URL(string: "https://example.com/")!,
            username: nil, permissions: .none
        )
    }
}
#endif
