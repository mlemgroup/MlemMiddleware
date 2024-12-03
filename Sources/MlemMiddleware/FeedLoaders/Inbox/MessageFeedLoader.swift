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

public class MessageFeedLoader: ChildFeedLoader<Message2, InboxItem> {
    override public func toParent(_ item: Message2) -> InboxItem {
        return .message(item)
    }
    
    public init(api: ApiClient, pageSize: Int, sortType: FeedLoaderSort.SortType) {
        super.init(fetcher: MessageFetcher(api: api, pageSize: pageSize, filter: .init()), sortType: sortType)
    }
}
