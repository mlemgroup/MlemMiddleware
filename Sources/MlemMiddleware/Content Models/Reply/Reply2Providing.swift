//
//  Reply2Providing.swift
//
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation

public protocol Reply2Providing: Reply1Providing, Interactable2Providing {
    var reply2: Reply2 { get }
    
    var reply1: Reply1 { get }
    var comment: Comment1 { get }
    var creator: Person1 { get }
    var post: Post1 { get }
    var community: Community1 { get }
    var recipient: Person1 { get }
    var subscribed: Bool { get }
    var commentCount: Int { get }
    var creatorIsModerator: Bool? { get }
    var creatorIsAdmin: Bool? { get }
    var bannedFromCommunity: Bool? { get }
}

public extension Reply2Providing {
    var reply1: Reply1 { reply2.reply1 }
    var comment: Comment1 { reply2.comment }
    var creator: Person1 { reply2.creator }
    var post: Post1 { reply2.post }
    var community: Community1 { reply2.community }
    var recipient: Person1 { reply2.recipient }
    var subscribed: Bool { reply2.subscribed }
    var commentCount: Int { reply2.commentCount }
    var creatorIsModerator: Bool? { reply2.creatorIsModerator }
    var creatorIsAdmin: Bool? { reply2.creatorIsAdmin }
    var bannedFromCommunity: Bool? { reply2.bannedFromCommunity }
    
    var reply1_: Reply1? { reply2.reply1 }
    var comment_: Comment1? { reply2.comment }
    var creator_: Person1? { reply2.creator }
    var post_: Post1? { reply2.post }
    var community_: Community1? { reply2.community }
    var recipient_: Person1? { reply2.recipient }
    var subscribed_: Bool? { reply2.subscribed }
    var commentCount_: Int? { reply2.commentCount }
    var creatorIsModerator_: Bool? { reply2.creatorIsModerator }
    var creatorIsAdmin_: Bool? { reply2.creatorIsAdmin }
    var bannedFromCommunity_: Bool? { reply2.bannedFromCommunity }
}

public extension Reply2Providing {
    private var votesManager: StateManager<VotesModel> { reply2.votesManager }
    private var savedManager: StateManager<Bool> { reply2.savedManager }
    
    func updateVote(_ newValue: ScoringOperation) {
        guard newValue != self.votes.myVote else { return }
        votesManager.performRequest(expectedResult: self.votes.applyScoringOperation(operation: newValue)) { semaphore in
            try await self.api.voteOnComment(id: self.commentId, score: newValue, semaphore: semaphore)
        }
    }
    
    func updateSaved(_ newValue: Bool) {
        savedManager.performRequest(expectedResult: newValue) { semaphore in
            try await self.api.saveComment(id: self.commentId, save: newValue, semaphore: semaphore)
        }
    }
}
