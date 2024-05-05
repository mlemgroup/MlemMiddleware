//
//  Post2.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import SwiftUI

@Observable
public final class Post2: Post2Providing {
    public var api: ApiClient
    public var post2: Post2 { self }
    
    public let post1: Post1
    
    public let creator: Person1
    public let community: Community1
    
    public var commentCount: Int
    public var unreadCommentCount: Int
    
    internal var votesManager: StateManager<VotesModel>
    public var votes: VotesModel { votesManager.wrappedValue }
    
    internal var isReadManager: StateManager<Bool>
    public var isRead: Bool { isReadManager.wrappedValue }
    
    internal var isSavedManager: StateManager<Bool>
    public var isSaved: Bool { isSavedManager.wrappedValue }
    
    public init(
        api: ApiClient,
        post1: Post1,
        creator: Person1,
        community: Community1,
        votes: VotesModel,
        commentCount: Int = 0,
        unreadCommentCount: Int = 0,
        isSaved: Bool = false,
        isRead: Bool = false
    ) {
        self.api = api
        self.post1 = post1
        self.creator = creator
        self.community = community
        self.votesManager = .init(wrappedValue: votes)
        self.commentCount = commentCount
        self.unreadCommentCount = unreadCommentCount
        self.isSavedManager = .init(wrappedValue: isSaved)
        self.isReadManager = .init(wrappedValue: isRead)
    }
}
