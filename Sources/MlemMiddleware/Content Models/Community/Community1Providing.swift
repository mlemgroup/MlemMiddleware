//
//  Community1Providing.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public protocol Community1Providing: CommunityStubProviding, Profile2Providing, ContentIdentifiable {
    var community1: Community1 { get }
    
    var removed: Bool { get }
    var deleted: Bool { get }
    var nsfw: Bool { get }
    var hidden: Bool { get }
    var onlyModeratorsCanPost: Bool { get }
    var blocked: Bool { get }
}

public typealias Community = Community1Providing

public extension Community1Providing {
    static var modelTypeId: String { "community" }
    
    var actorId: URL { community1.actorId }
    var name: String { community1.name }
    
    var id: Int { community1.id }
    var created: Date { community1.created }
    var updated: Date? { community1.updated }
    var displayName: String { community1.displayName }
    var description: String? { community1.description }
    var removed: Bool { community1.removed }
    var deleted: Bool { community1.deleted }
    var nsfw: Bool { community1.nsfw }
    var avatar: URL? { community1.avatar }
    var banner: URL? { community1.banner }
    var hidden: Bool { community1.hidden }
    var onlyModeratorsCanPost: Bool { community1.onlyModeratorsCanPost }
    var blocked: Bool { community1.blocked }
    
    var id_: Int? { community1.id }
    var created_: Date? { community1.created }
    var updated_: Date? { community1.updated }
    var displayName_: String? { community1.displayName }
    var description_: String? { community1.description }
    var removed_: Bool? { community1.removed }
    var deleted_: Bool? { community1.deleted }
    var nsfw_: Bool? { community1.nsfw }
    var avatar_: URL? { community1.avatar }
    var banner_: URL? { community1.banner }
    var hidden_: Bool? { community1.hidden }
    var onlyModeratorsCanPost_: Bool? { community1.onlyModeratorsCanPost }
    var blocked_: Bool? { community1.blocked }
}

// SelectableContentProviding conformance
public extension Community1Providing {
    var selectableContent: String? { description }
}

public extension Community1Providing {
    private var blockedManager: StateManager<Bool> { community1.blockedManager }
    
    func upgrade() async throws -> any Community {
        try await api.getCommunity(id: id)
    }
    
    func getPosts(
        sort: ApiSortType,
        page: Int = 1,
        cursor: String? = nil,
        limit: Int,
        filter: GetContentFilter? = nil,
        showHidden: Bool = false
    ) async throws -> (posts: [Post2], cursor: String?) {
        try await api.getPosts(
            communityId: id,
            sort: sort,
            page: page,
            cursor: cursor,
            limit: limit,
            filter: filter,
            showHidden: showHidden
        )
    }
    
    func updateBlocked(_ newValue: Bool) {
        blockedManager.performRequest(expectedResult: newValue) { semaphore in
            try await self.api.blockCommunity(id: self.id, block: newValue, semaphore: semaphore)
        }
    }
    
    func toggleBlocked() {
        updateBlocked(!blocked)
    }
}
