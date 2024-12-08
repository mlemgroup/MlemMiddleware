//
//  ReplyFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-27.
//

class ReplyFetcher: InboxFetcher {
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        let response = try await api.getReplies(page: page, limit: pageSize)
        return .init(
            items: response.map { .reply($0) },
            prevCursor: nil,
            nextCursor: nil
        )
    }
}

public class ReplyFeedLoader: InboxChildFeedLoader {
    public init(api: ApiClient, pageSize: Int, sortType: FeedLoaderSort.SortType, showRead: Bool) {
        super.init(api: api, sortType: sortType, fetcher: ReplyFetcher(api: api, pageSize: pageSize, unreadOnly: !showRead), showRead: showRead)
    }
}
