//
//  Post2Providing.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation
import Nuke

public protocol Post2Providing: Post1Providing, Interactable2Providing, PersonContentProviding, ReadableProviding {
    var post2: Post2 { get }
    
    var creator: any Person { get }
    var community: any Community { get }
    var unreadCommentCount: Int { get }
    var read: Bool { get }
    var hidden: Bool { get }
}

public extension Post2Providing {
    var post1: Post1 { post2.post1 }
    
    var creator: any Person { post2.creator }
    var community: any Community { post2.community }
    var creatorIsModerator: Bool? { post2.creatorIsModerator }
    var creatorIsAdmin: Bool? { post2.creatorIsAdmin }
    var bannedFromCommunity: Bool { post2.bannedFromCommunity }
    var commentCount: Int { post2.commentCount }
    var unreadCommentCount: Int { post2.unreadCommentCount }
    var votes: VotesModel { post2.votes }
    var saved: Bool { post2.saved }
    var read: Bool { post2.read }
    var hidden: Bool { post2.hidden }
    
    var creator_: (any Person)? { post2.creator }
    var community_: (any Community)? { post2.community }
    var creatorIsModerator_: Bool? { post2.creatorIsModerator }
    var creatorIsAdmin_: Bool? { post2.creatorIsAdmin }
    var bannedFromCommunity_: Bool? { post2.bannedFromCommunity }
    var commentCount_: Int? { post2.commentCount }
    var unreadCommentCount_: Int? { post2.unreadCommentCount }
    var votes_: VotesModel? { post2.votes }
    var saved_: Bool? { post2.saved }
    var read_: Bool? { post2.read }
    var hidden_: Bool? { post2.hidden }
}

public extension Post2Providing {
    private var votesManager: StateManager<VotesModel> { post2.votesManager }
    private var readManager: StateManager<Bool> { post2.readManager }
    private var savedManager: StateManager<Bool> { post2.savedManager }
    private var hiddenManager: StateManager<Bool> { post2.hiddenManager }
        
    @discardableResult
    func updateRead(_ newValue: Bool, shouldQueue: Bool = false) -> Task<StateUpdateResult, Never> {
        if shouldQueue {
            return Task { @MainActor in
                if newValue {
                    await api.markReadQueue.add(self.id)
                    post2.updateReadQueued(true)
                } else {
                    await api.markReadQueue.remove(self.id)
                    post2.updateReadQueued(false)
                }
                return .deferred
            }
        } else {
            return readManager.performRequest(expectedResult: newValue) { semaphore in
                try await self.api.markPostAsRead(id: self.id, read: newValue, includeQueuedPosts: true, semaphore: semaphore)
            }
        }
    }
    
    @discardableResult
    func toggleRead(shouldQueue: Bool = false) -> Task<StateUpdateResult, Never> {
        updateRead(!read, shouldQueue: shouldQueue)
    }

    @discardableResult
    func updateVote(_ newValue: ScoringOperation) -> Task<StateUpdateResult, Never> {
        groupStateRequest(
            votesManager.ticket(self.votes.applyScoringOperation(operation: newValue)),
            readManager.ticket(true)
        ) { semaphore in
            try await self.api.voteOnPost(id: self.id, score: newValue, semaphore: semaphore)
        }
    }
    
    @discardableResult
    func updateSaved(_ newValue: Bool) -> Task<StateUpdateResult, Never> {
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
    
    @discardableResult
    func toggleHidden() -> Task<StateUpdateResult, Never> {
        updateHidden(!hidden)
    }
    
    @discardableResult
    func updateHidden(_ newValue: Bool) -> Task<StateUpdateResult, Never> {
        // Unlike other post operations, this one does not mark the post as read
        hiddenManager.performRequest(expectedResult: newValue) { semaphore in
            try await self.api.hidePost(id: self.id, hide: newValue, semaphore: semaphore)
        }
    }
    
    /// Generates an array of image requests to fetch all images associated with this Post2Providing.
    /// If configuration specifies any embeddings, parses and handles them before creating the ImageRequests.
    func imageRequests(configuration config: PrefetchingConfiguration) async -> [ImageRequest] {
        var ret: [ImageRequest] = .init()
        
        // handle loops.video embedding
        if config.embedLoops {
            await parseLoopEmbeds()
        }
        
        // preload user and community avatars--fetching both because we don't know which we'll need, but these are super tiny
        // so it's probably not an API crime, right?
        if let avatarSize = config.avatarSize {
            if let communityAvatarLink = community.avatar {
                ret.append(ImageRequest(url: communityAvatarLink.withIconSize(avatarSize)))
            }
            
            if let userAvatarLink = creator.avatar {
                ret.append(ImageRequest(url: userAvatarLink.withIconSize(avatarSize)))
            }
        }
        
        switch type {
        case let .media(url, thumbnail), let .embedded(url, thumbnail, _):
            // media/embedded media: only load the media
            switch config.imageSize {
            case .unlimited:
                ret.append(ImageRequest(url: url, priority: .high))
                if let thumbnail, url.proxyAwarePathExtension?.isMovieExtension ?? false {
                    ret.append(ImageRequest(url: thumbnail, priority: .high))
                }
            case let .limited(size):
                ret.append(ImageRequest(url: url.withIconSize(size), priority: .high))
                if let thumbnail, url.proxyAwarePathExtension?.isMovieExtension ?? false {
                    ret.append(ImageRequest(url: thumbnail.withIconSize(size), priority: .high))
                }
            }
        case let .link(link):
            // websites: load image and favicon
            if config.fetchFavicons, let url = link.favicon {
                ret.append(ImageRequest(url: url))
            }
            if let url = link.thumbnail {
                switch config.imageSize {
                case .unlimited:
                    ret.append(ImageRequest(url: url, priority: .high))
                case let .limited(size):
                    ret.append(ImageRequest(url: url.withIconSize(size), priority: .high))
                }
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
