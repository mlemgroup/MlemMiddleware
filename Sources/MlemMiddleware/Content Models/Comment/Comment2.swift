//
//  Comment2.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation
import Observation

@Observable
public final class Comment2: Comment2Providing {
    public static let tierNumber: Int = 2
    public var api: ApiClient
    public var comment2: Comment2 { self }
    
    public let comment1: Comment1
    
    public let creator: Person1
    public let post: Post1
    public let community: Community1
    
    public var creatorIsModerator: Bool?
    public var creatorIsAdmin: Bool?
    public var bannedFromCommunity: Bool?
    public var commentCount: Int
    
    internal var votesManager: StateManager<VotesModel>
    public var votes: VotesModel { votesManager.wrappedValue }
    
    internal var savedManager: StateManager<Bool>
    public var saved: Bool { savedManager.wrappedValue }
    
    internal init(
        api: ApiClient,
        comment1: Comment1,
        creator: Person1,
        post: Post1,
        community: Community1,
        votes: VotesModel,
        saved: Bool,
        creatorIsModerator: Bool?,
        creatorIsAdmin: Bool?,
        bannedFromCommunity: Bool?, 
        commentCount: Int
    ) {
        self.api = api
        self.comment1 = comment1
        self.creator = creator
        self.post = post
        self.community = community
        self.votesManager = .init(wrappedValue: votes)
        self.savedManager = .init(wrappedValue: saved)
        self.creatorIsModerator = creatorIsModerator
        self.creatorIsAdmin = creatorIsAdmin
        self.bannedFromCommunity = bannedFromCommunity
        self.commentCount = commentCount
    }
}
