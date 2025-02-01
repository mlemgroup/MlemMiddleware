//
//  InboxItem.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2025-02-01.
//

public enum InboxItem: FeedLoadable, ReadableProviding, InboxIdentifiable {
    public typealias FilterType = InboxItemFilterType
    
    case message(Message2)
    case reply(Reply2)
    
    var baseValue: any FeedLoadable & ActorIdentifiable {
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
    
    public var inboxId: Int {
        var hasher: Hasher = .init()
        
        switch self {
        case let .message(message): hasher.combine(message.actorId)
        case let .reply(reply): hasher.combine(reply.actorId)
        }
        
        return hasher.finalize()
    }
}
