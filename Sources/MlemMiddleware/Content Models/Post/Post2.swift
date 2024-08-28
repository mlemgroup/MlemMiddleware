//
//  Post2.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Observation

@Observable
public final class Post2: Post2Providing {
    public static let tierNumber: Int = 2
    public var api: ApiClient
    public var post2: Post2 { self }
    
    public let post1: Post1
    
    public let creator: Person1
    public let community: Community1
    
    public var creatorIsModerator: Bool?
    public var creatorIsAdmin: Bool?
    public var bannedFromCommunity: Bool?
    public var commentCount: Int
    public var unreadCommentCount: Int
    
    internal var votesManager: StateManager<VotesModel>
    public var votes: VotesModel { votesManager.wrappedValue }
    
    internal var readManager: StateManager<Bool>
    public var read: Bool { readManager.wrappedValue || readQueued }
    internal var readStaged: Bool = false
    internal var readQueued: Bool = false
    
    internal var savedManager: StateManager<Bool>
    public var saved: Bool { savedManager.wrappedValue }
    
    internal var hiddenManager: StateManager<Bool>
    public var hidden: Bool { hiddenManager.wrappedValue }
    
    internal init(
        api: ApiClient,
        post1: Post1,
        creator: Person1,
        community: Community1,
        votes: VotesModel,
        creatorIsModerator: Bool?,
        creatorIsAdmin: Bool?,
        bannedFromCommunity: Bool?,
        commentCount: Int = 0,
        unreadCommentCount: Int = 0,
        saved: Bool = false,
        read: Bool = false,
        hidden: Bool = false
    ) {
        self.api = api
        self.post1 = post1
        self.creator = creator
        self.community = community
        self.votesManager = .init(wrappedValue: votes)
        self.creatorIsModerator = creatorIsModerator
        self.creatorIsAdmin = creatorIsAdmin
        self.bannedFromCommunity = bannedFromCommunity
        self.commentCount = commentCount
        self.unreadCommentCount = unreadCommentCount
        self.savedManager = .init(wrappedValue: saved)
        self.readManager = .init(wrappedValue: read)
        self.hiddenManager = .init(wrappedValue: hidden)
    }
}
