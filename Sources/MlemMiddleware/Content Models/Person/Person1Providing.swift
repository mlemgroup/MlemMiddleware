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
        SelectableContentProviding {
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
    func sortVal(sortType: FeedLoaderSortType) -> FeedLoaderSortVal {
        switch sortType {
        case .published:
            return .published(created)
        }
    }
}

// SelectableContentProviding conformance
public extension Person1Providing {
    var selectableContent: String? { description }
}

public extension Person1Providing {
    private var blockedManager: StateManager<Bool> { person1.blockedManager }
    
    func upgrade() async throws -> any Person {
        try await api.getPerson(id: id)
    }
    
    func getPosts(
        community: (any Community)? = nil,
        sort: ApiSortType = .new,
        page: Int,
        limit: Int,
        savedOnly: Bool = false
    ) async throws -> (person: Person3, posts: [Post2]) {
        return try await api.getPosts(
            personId: id,
            communityId: community?.id,
            page: page,
            limit: limit,
            savedOnly: savedOnly
        )
    }
    
    func updateBlocked(_ newValue: Bool) {
        blockedManager.performRequest(expectedResult: newValue) { semaphore in
            try await self.api.blockPerson(id: self.id, block: newValue, semaphore: semaphore)
        }
    }
    
    func toggleBlocked() {
        updateBlocked(!blocked)
    }
}
