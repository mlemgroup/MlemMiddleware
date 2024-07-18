//
//  FeedLoadable.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-10-15.
//

import Foundation

public protocol FeedLoadable: ActorIdentifiable, AnyObject, Filterable {
    associatedtype FilterType
    
    func sortVal(sortType: FeedLoaderSort.SortType) -> FeedLoaderSort
    
    static func == (lhs: any FeedLoadable, rhs: any FeedLoadable) -> Bool
}

public extension FeedLoadable {
    static func == (lhs: any FeedLoadable, rhs: any FeedLoadable) -> Bool {
        lhs.actorId == rhs.actorId
    }
}
