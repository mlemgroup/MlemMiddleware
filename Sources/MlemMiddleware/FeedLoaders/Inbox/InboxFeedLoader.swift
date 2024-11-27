//
//  InboxFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-26.
//

import Foundation

enum InboxItem: FeedLoadable {
    typealias FilterType = InboxItemFilterType
    
    case message(Message2)
    case reply(Reply2)
    
    var baseValue: any FeedLoadable {
        switch self {
        case let .message(message2): message2
        case let .reply(reply2): reply2
        }
    }
    
    var api: ApiClient { baseValue.api }
    
    func sortVal(sortType: FeedLoaderSort.SortType) -> FeedLoaderSort {
        baseValue.sortVal(sortType: sortType)
    }
    
    var actorId: URL {
        baseValue.actorId
    }
}

//class AnyInboxItem: FeedLoadable {
//    
//}

class InboxFetcher: MultiFetcher<InboxItem> {
    
}

class InboxFeedLoader: StandardFeedLoader<InboxItem> {
    init(api: ApiClient, pageSize: Int, sources: [any ChildFeedLoading], sortType: FeedLoaderSort.SortType) {
        super.init(filter: .init(), fetcher: MultiFetcher(api: api, pageSize: pageSize, sources: sources, sortType: sortType))
    }
}

class MyStupidClass {
    var hi: Int
}
