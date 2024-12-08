//
//  MessageFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-26.
//

class MessageFetcher: InboxFetcher {
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        let response = try await api.getMessages(page: page, limit: pageSize)
        return .init(
            items: response.map { .message($0) },
            prevCursor: nil,
            nextCursor: nil
        )
    }
}

public class MessageFeedLoader: InboxChildFeedLoader {
    public init(api: ApiClient, pageSize: Int, sortType: FeedLoaderSort.SortType, showRead: Bool) {
        super.init(api: api, sortType: sortType, fetcher: MessageFetcher(api: api, pageSize: pageSize, unreadOnly: !showRead), showRead: showRead)
    }
}
