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

public class ReplyFeedLoader: ChildFeedLoader<Reply2, InboxItem> {
    override public func toParent(_ item: Reply2) -> InboxItem {
        return .reply(item)
    }
    
    public init(api: ApiClient, pageSize: Int, sortType: FeedLoaderSort.SortType) {
        super.init(fetcher: ReplyFetcher(api: api, pageSize: pageSize, filter: .init()), sortType: sortType)
    }
}
