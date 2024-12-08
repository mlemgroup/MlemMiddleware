//
//  InboxFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-27.
//

import Foundation

public enum InboxItem: FeedLoadable, ReadableProviding {
    public typealias FilterType = InboxItemFilterType
    
    case message(Message2)
    case reply(Reply2)
    
    var baseValue: any FeedLoadable {
        switch self {
        case let .message(message2): message2
        case let .reply(reply2): reply2
        }
    }
    
    public var read: Bool {
        switch self {
        case .message(let message2): message2.read
        case .reply(let reply2): reply2.read
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
    
    var inboxFetcher: MultiFetcher<InboxItem> { fetcher as! MultiFetcher }
    
    public init(api: ApiClient, pageSize: Int, sources: [ChildFeedLoader<InboxItem>], sortType: FeedLoaderSort.SortType, showRead: Bool) {
        super.init(filter: InboxItemFilter(showRead: showRead), fetcher: MultiFetcher(api: api, pageSize: pageSize, sources: sources, sortType: sortType))
        
        sources.forEach { source in
            source.setParent(parent: self)
        }
    }
    
    public func hideRead() async throws {
        await withThrowingTaskGroup(of: Void.self) { group in
            inboxFetcher.sources.forEach { source in
                group.addTask {
                    guard let childSource = source as? InboxChildFeedLoader else {
                        assertionFailure("Child is not InboxChildFeedLoader")
                        return
                    }
                    try await childSource.hideRead()
                }
            }
        }
        
        try await activateFilter(.read)
    }
    
    public func showRead() async throws {
        await withThrowingTaskGroup(of: Void.self) { group in
            inboxFetcher.sources.forEach { source in
                group.addTask {
                    guard let childSource = source as? InboxChildFeedLoader else {
                        assertionFailure("Child is not InboxChildFeedLoader")
                        return
                    }
                    try await childSource.showRead()
                }
            }
        }

        try await deactivateFilter(.read)
    }
}
