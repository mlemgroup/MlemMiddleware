//
//  Interactable2Providing.swift
//  Mlem
//
//  Created by Sjmarf on 17/02/2024.
//

import Foundation

// Content that can be upvoted, downvoted, saved etc
public protocol Interactable2Providing: Interactable1Providing {
    var commentCount: Int { get }
    
    var votes: VotesModel { get }
    var saved: Bool { get }
    
    func vote(_ newVote: ScoringOperation)
    func toggleSave()
}

public extension Interactable2Providing {
    func toggleUpvote() { vote(votes.myVote == .upvote ? .none : .upvote) }
    func toggleDownvote() { vote(votes.myVote == .downvote ? .none : .downvote) }
}
