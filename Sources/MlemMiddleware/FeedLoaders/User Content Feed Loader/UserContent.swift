//
//  UserContent.swift
//  
//
//  Created by Eric Andrews on 2024-07-21.
//

import Foundation

public class UserContent: Hashable, Equatable, FeedLoadable {
    public typealias FilterType = UserContentFilterType
    
    public let wrappedValue: Value
    
    public enum Value {
        // This always comes from GetPersonDetailsRequest, so we can know we're getting Post2 and Comment2
        case post(Post2)
        case comment(Comment2)
    }
    
    public init(wrappedValue: UserContent.Value) {
        self.wrappedValue = wrappedValue
    }
    
    public func sortVal(sortType: FeedLoaderSort.SortType) -> FeedLoaderSort {
        switch wrappedValue {
        case let .post(post2): post2.sortVal(sortType: sortType)
        case let .comment(comment2): comment2.sortVal(sortType: sortType)
        }
    }
    
    public var actorId: URL {
        switch wrappedValue {
        case let .post(post2): post2.actorId
        case let .comment(comment2): comment2.actorId
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        // TODO: better conformance
        switch wrappedValue {
        case let .post(post2):
            hasher.combine(post2)
            hasher.combine(ContentType.post)
        case let .comment(comment2):
            hasher.combine(comment2)
            hasher.combine(ContentType.comment)
        }
    }
    
    public static func == (lhs: UserContent, rhs: UserContent) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
