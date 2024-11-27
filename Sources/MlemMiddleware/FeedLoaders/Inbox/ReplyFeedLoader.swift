//
//  ReplyFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-27.
//

class ReplyFetcher: Fetcher<Reply2> {
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        let response = try await api.getReplies(page: page, limit: pageSize)
        return .init(items: response, prevCursor: nil, nextCursor: nil)
    }
}

public class ReplyFeedLoader: StandardFeedLoader<Reply2> {
    public init(api: ApiClient, pageSize: Int) {
        super.init(filter: .init(), fetcher: ReplyFetcher(api: api, pageSize: pageSize))
    }
}
