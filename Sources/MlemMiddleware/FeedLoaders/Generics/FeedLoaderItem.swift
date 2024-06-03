//
//  FeedLoadable.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-10-15.
//

import Foundation

public protocol FeedLoadable: Equatable, AnyObject {
    associatedtype OptionalFilters
    
    var uid: ContentModelIdentifier { get }
    func sortVal(sortType: FeedLoaderSortType) -> FeedLoaderSortVal
    
    static func == (lhs: any FeedLoadable, rhs: any FeedLoadable) -> Bool
}

public extension FeedLoadable {
    static func == (lhs: any FeedLoadable, rhs: any FeedLoadable) -> Bool {
        lhs.uid == rhs.uid
    }
}
