//
//  MessageFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-26.
//

class MessageFetcher: Fetcher<InboxItem> {
    override func fetchPage(_ page: Int) async throws -> FetchResponse {
        let response = try await api.getMessages(page: page, limit: pageSize)
        return .init(
            items: response.map { .message($0) },
            prevCursor: nil,
            nextCursor: nil
        )
    }
    
    /// Updates fetching behavior to hide read posts.
    /// - Parameter unreadCount: number of unread items still present after client-side filtering
    func hideRead(unreadCount: Int) {
        // TODO:
        // - update unreadOnly
        // - compute new page using unreadCount
        // - add deduper to StandardFeedLoader
    }
    
    /// Updates fetching behavior to show read posts. Resets the fetcher.
    func showRead() {
        // TODO: implement
    }
}

public class MessageFeedLoader: ChildFeedLoader<InboxItem> {
//    override public func toParent(_ item: Message2) -> InboxItem {
//        return .message(item)
//    }
    
    public init(api: ApiClient, pageSize: Int, sortType: FeedLoaderSort.SortType) {
        super.init(filter: .init(), fetcher: MessageFetcher(api: api, pageSize: pageSize), sortType: sortType)
    }
}
