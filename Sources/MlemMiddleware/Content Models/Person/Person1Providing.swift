//
//  User1Providing.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public protocol Person1Providing:
        PersonStubProviding,
        Profile2Providing,
        ContentIdentifiable,
        SelectableContentProviding,
        PurgableProviding,
        FeedLoadable where FilterType == PersonFilterType
{
    var api: ApiClient { get }
    
    var person1: Person1 { get }
    
    var matrixId: String? { get }
    var deleted: Bool { get }
    var isBot: Bool { get }
    var instanceBan: InstanceBanType { get }
    
    var blocked: Bool { get }
}

public typealias Person = Person1Providing

public extension Person1Providing {
    static var modelTypeId: ContentType { .person }
    
    var actorId: URL { person1.actorId }
    var id: Int { person1.id }
    var name: String { person1.name }
    
    var created: Date { person1.created }
    var updated: Date? { person1.updated }
    var displayName: String { person1.displayName }
    var description: String? { person1.description }
    var matrixId: String? { person1.matrixId }
    var avatar: URL? { person1.avatar }
    var banner: URL? { person1.banner }
    var deleted: Bool { person1.deleted }
    var isBot: Bool { person1.isBot }
    var instanceBan: InstanceBanType { person1.instanceBan }
    var blocked: Bool { person1.blocked }
    var purged: Bool { person1.purged }
    
    var id_: Int? { person1.id }
    var created_: Date? { person1.created }
    var updated_: Date? { person1.updated }
    var displayName_: String? { person1.displayName }
    var description_: String? { person1.description }
    var matrixId_: String? { person1.matrixId }
    var avatar_: URL? { person1.avatar }
    var banner_: URL? { person1.banner }
    var deleted_: Bool? { person1.deleted }
    var isBot_: Bool? { person1.isBot }
    var instanceBan_: InstanceBanType? { person1.instanceBan }
    var blocked_: Bool? { person1.blocked }
}

// FeedLoadable conformance
public extension Person1Providing {
    func sortVal(sortType: FeedLoaderSort.SortType) -> FeedLoaderSort {
        switch sortType {
        case .new:
            return .new(created)
        }
    }
}

// SelectableContentProviding conformance
public extension Person1Providing {
    var selectableContent: String? { description }
}

public extension Person1Providing {
    private var blockedManager: StateManager<Bool> { person1.blockedManager }

    var bannedFromInstance: Bool { instanceBan != .notBanned }

    func upgrade() async throws -> any Person {
        try await api.getPerson(id: id)
    }
    
    func getContent(
        community: (any Community)? = nil,
        sort: ApiSortType = .new,
        page: Int,
        limit: Int,
        savedOnly: Bool = false
    ) async throws -> (person: Person3, posts: [Post2], comments: [Comment2]) {
        return try await api.getContent(
            authorId: id,
            sort: sort,
            page: page,
            limit: limit,
            savedOnly: savedOnly,
            communityId: community?.id)
    }
    
    @discardableResult
    func updateBlocked(_ newValue: Bool) -> Task<StateUpdateResult, Never> {
        blockedManager.performRequest(expectedResult: newValue) { semaphore in
            try await self.api.blockPerson(id: self.id, block: newValue, semaphore: semaphore)
        }
    }
    
    @discardableResult
    func toggleBlocked() -> Task<StateUpdateResult, Never> {
        updateBlocked(!blocked)
    }
    
    func ban(from community: any Community, removeContent: Bool, reason: String?, expires: Date?) async throws {
        try await api.banPersonFromCommunity(
            personId: self.id,
            communityId: community.id,
            ban: true,
            removeContent: removeContent,
            reason: reason,
            expires: expires
        )
    }
    
    func unban(from community: any Community, reason: String?) async throws {
        try await api.banPersonFromCommunity(
            personId: self.id,
            communityId: community.id,
            ban: false,
            removeContent: false,
            reason: reason
        )
    }
    
    func purge(reason: String?) async throws {
        try await api.purgePerson(id: id, reason: reason)
    }
    
    func banFromInstance(removeContent: Bool, reason: String?, expires: Date?) async throws {
        try await api.banPersonFromInstance(
            personId: self.id,
            ban: true,
            removeContent: removeContent,
            reason: reason,
            expires: expires
        )
    }
    
    func unbanFromInstance(reason: String?) async throws {
        try await api.banPersonFromInstance(
            personId: self.id,
            ban: false,
            removeContent: false,
            reason: reason,
            expires: nil
        )
    }
}
