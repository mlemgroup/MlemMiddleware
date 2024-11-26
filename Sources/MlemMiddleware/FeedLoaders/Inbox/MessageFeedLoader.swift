//
//  MessageFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-26.
//

class MessageFetcher: Fetcher<Message2> {
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        let response = try await api.getMessages(page: page, limit: pageSize)
        return .init(items: response, prevCursor: nil, nextCursor: nil)
    }
}

public class MessageFeedLoader: StandardFeedLoader<Message2> {
    public init(api: ApiClient, pageSize: Int) {
        super.init(filter: .init(), fetcher: .init(api: api, pageSize: pageSize))
    }
}
