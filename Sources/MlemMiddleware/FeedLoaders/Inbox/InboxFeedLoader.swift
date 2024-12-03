//
//  InboxFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-27.
//

import Foundation

public enum InboxItem: FeedLoadable {
    public typealias FilterType = InboxItemFilterType
    
    case message(Message2)
    case reply(Reply2)
    
    var baseValue: any FeedLoadable {
        switch self {
        case let .message(message2): message2
        case let .reply(reply2): reply2
        }
    }
    
    public var api: ApiClient { baseValue.api }
    
    public func sortVal(sortType: FeedLoaderSort.SortType) -> FeedLoaderSort {
        baseValue.sortVal(sortType: sortType)
    }
    
    public var actorId: URL {
        baseValue.actorId
    }
}

public class InboxFeedLoader: StandardFeedLoader<InboxItem> {
    public init(api: ApiClient, pageSize: Int, sources: [any ChildFeedLoading], sortType: FeedLoaderSort.SortType) {
        super.init(fetcher: MultiFetcher(api: api, pageSize: pageSize, filter: .init(), sources: sources, sortType: sortType))
        
        sources.forEach { source in
            source.setParent(parent: self)
        }
    }
}
