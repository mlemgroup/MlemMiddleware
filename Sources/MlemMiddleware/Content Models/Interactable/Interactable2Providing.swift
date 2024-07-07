//
//  Interactable2Providing.swift
//  Mlem
//
//  Created by Sjmarf on 17/02/2024.
//

import Foundation

// Content that can be upvoted, downvoted, saved etc
public protocol Interactable2Providing: Interactable1Providing {
    var creator: Person1 { get }
    var commentCount: Int { get }
    
    var votes: VotesModel { get }
    var saved: Bool { get }
    
    func updateVote(_ newVote: ScoringOperation)
    func updateSaved(_ newValue: Bool)
}

public extension Interactable2Providing {
    func toggleUpvoted() { updateVote(votes.myVote == .upvote ? .none : .upvote) }
    func toggleDownvoted() { updateVote(votes.myVote == .downvote ? .none : .downvote) }
    func toggleSaved() { updateSaved(!saved) }
}
