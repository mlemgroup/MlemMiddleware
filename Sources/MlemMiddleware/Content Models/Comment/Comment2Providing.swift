//
//  Comment2Providing.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

public protocol Comment2Providing: Comment1Providing, Interactable2Providing {
    var comment2: Comment2 { get }
    
    var creator: Person1 { get }
    var post: Post1 { get }
    var community: Community1 { get }
    var creatorIsModerator: Bool? { get }
    var creatorIsAdmin: Bool? { get }
    var bannedFromCommunity: Bool? { get }
}

public extension Comment2Providing {
    var comment1: Comment1 { comment2.comment1 }
    var interactable1: Comment1 { comment1 }
    
    var creator: Person1 { comment2.creator }
    var post: Post1 { comment2.post }
    var community: Community1 { comment2.community }
    var votes: VotesModel { comment2.votes }
    var creatorIsModerator: Bool? { comment2.creatorIsModerator }
    var creatorIsAdmin: Bool? { comment2.creatorIsAdmin }
    var bannedFromCommunity: Bool? { comment2.bannedFromCommunity }
    var commentCount: Int { comment2.commentCount }
    
    var creator_: Person1? { comment2.creator }
    var post_: Post1? { comment2.post }
    var community_: Community1? { comment2.community }
    var votes_: VotesModel? { comment2.votes }
    var creatorIsModerator_: Bool? { comment2.creatorIsModerator }
    var creatorIsAdmin_: Bool? { comment2.creatorIsAdmin }
    var bannedFromCommunity_: Bool? { comment2.bannedFromCommunity }
    var commentCount_: Int? { comment2.commentCount }
}

public extension Comment2Providing {
    private var votesManager: StateManager<VotesModel> { comment2.votesManager }
    private var savedManager: StateManager<Bool> { comment2.savedManager }
    
    func upgrade() async throws -> any Comment { self }
    
    func updateVote(_ newValue: ScoringOperation) {
        guard newValue != self.votes.myVote else { return }
        votesManager.performRequest(expectedResult: self.votes.applyScoringOperation(operation: newValue)) { semaphore in
            try await self.api.voteOnComment(id: self.id, score: newValue, semaphore: semaphore)
        }
    }
    
    func updateSave(_ newValue: Bool) {
        savedManager.performRequest(expectedResult: newValue) { semaphore in
            try await self.api.saveComment(id: self.id, save: newValue, semaphore: semaphore)
        }
    }
}
