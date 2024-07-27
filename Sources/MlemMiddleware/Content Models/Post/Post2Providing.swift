//
//  Post2Providing.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation
import Nuke

public protocol Post2Providing: Post1Providing, Interactable2Providing, PersonContentProviding {
    var post2: Post2 { get }
    
    var creator: Person1 { get }
    var community: Community1 { get }
    var unreadCommentCount: Int { get }
    var read: Bool { get }
}

public extension Post2Providing {
    var post1: Post1 { post2.post1 }
    
    var creator: Person1 { post2.creator }
    var community: Community1 { post2.community }
    var commentCount: Int { post2.commentCount }
    var votes: VotesModel { post2.votes }
    var unreadCommentCount: Int { post2.unreadCommentCount }
    var saved: Bool { post2.saved }
    var read: Bool { post2.read }
    
    var creator_: Person1? { post2.creator }
    var community_: Community1? { post2.community }
    var commentCount_: Int? { post2.commentCount }
    var votes_: VotesModel? { post2.votes }
    var unreadCommentCount_: Int? { post2.unreadCommentCount }
    var saved_: Bool? { post2.saved }
    var read_: Bool? { post2.read }
}

public extension Post2Providing {
    private var votesManager: StateManager<VotesModel> { post2.votesManager }
    private var readManager: StateManager<Bool> { post2.readManager }
    private var savedManager: StateManager<Bool> { post2.savedManager }
    
    func upgrade() async throws -> any Post { self }
    
    func updateRead(_ newValue: Bool, shouldQueue: Bool = false) {
        if shouldQueue {
            Task {
                if newValue {
                    await api.markReadQueue.add(self.id)
                    post2.readQueued = true
                } else {
                    await api.markReadQueue.remove(self.id)
                    post2.readQueued = false
                }
            }
        } else {
            readManager.performRequest(expectedResult: newValue) { semaphore in
                try await self.api.markPostAsRead(id: self.id, read: newValue, semaphore: semaphore)
            }
        }
    }
    
    func toggleRead(shouldQueue: Bool = false) {
        updateRead(!read, shouldQueue: shouldQueue)
    }

    func updateVote(_ newValue: ScoringOperation) {
        guard newValue != self.votes.myVote else { return }
        groupStateRequest(
            votesManager.ticket(self.votes.applyScoringOperation(operation: newValue)),
            readManager.ticket(true)
        ) { semaphore in
            try await self.api.voteOnPost(id: self.id, score: newValue, semaphore: semaphore)
        }
    }
    
    func updateSaved(_ newValue: Bool) {
        groupStateRequest(
            savedManager.ticket(newValue),
            readManager.ticket(true)
        ) { semaphore in
            try await self.api.savePost(id: self.id, save: newValue, semaphore: semaphore)
        }
    }
    
    var queuedForMarkAsRead: Bool {
        get async { await api.markReadQueue.ids.contains(self.id) }
    }
    
    /// Generates an array of image requests to fetch all images associated with this Post2Providing
    func imageRequests(smallAvatarIconSize: Int, largeAvatarIconSize: Int) -> [ImageRequest] {
        var ret: [ImageRequest] = .init()
        
        // preload user and community avatars--fetching both because we don't know which we'll need, but these are super tiny
        // so it's probably not an API crime, right?
        if let communityAvatarLink = community.avatar {
            ret.append(ImageRequest(url: communityAvatarLink.withIconSize(smallAvatarIconSize)))
        }
        
        if let userAvatarLink = creator.avatar {
            ret.append(ImageRequest(url: userAvatarLink.withIconSize(largeAvatarIconSize * 2)))
        }
        
        switch type {
        case let .image(url):
            // images: only load the image
            ret.append(ImageRequest(url: url, priority: .high))
        case let .link(url):
            // websites: load image and favicon
            if let baseURL = linkUrl?.host,
               let favIconURL = URL(string: "https://www.google.com/s2/favicons?sz=64&domain=\(baseURL)") {
                ret.append(ImageRequest(url: favIconURL))
            }
            if let url {
                ret.append(ImageRequest(url: url, priority: .high))
            }
        default:
            break
        }
        
        return ret
    }
}

// PersonContentProviding conformance
public extension Post2Providing {
    var userContent: PersonContent { .init(wrappedValue: .post(post2)) }
}
