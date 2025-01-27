//
//  NewApiClient+User.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public extension ApiClient {
    func decodePerson(_ data: Person1.CodedData) async throws -> Person1 {
        guard data.apiUrl == baseUrl else {
            throw ApiClientError.mismatchingUrl
        }
        guard data.apiMyPersonId == (try await myPersonId) else {
            throw ApiClientError.mismatchingPersonId
        }
        return await caches.person1.getModel(api: self, from: data.apiPerson, isStale: true)
    }
    
    func decodePerson(_ data: Person2.CodedData) async throws -> Person2 {
        guard data.apiUrl == baseUrl else {
            throw ApiClientError.mismatchingUrl
        }
        guard data.apiMyPersonId == (try await myPersonId) else {
            throw ApiClientError.mismatchingPersonId
        }
        return await caches.person2.getModel(api: self, from: data.apiPersonView, isStale: true)
    }
    
    func getPerson(id: Int) async throws -> Person3 {
        let request = GetPersonDetailsRequest(
            personId: id,
            username: nil,
            sort: .new,
            page: 1,
            limit: 1,
            communityId: nil,
            savedOnly: nil
        )
        let response = try await perform(request)
        return await caches.person3.getModel(api: self, from: response)
    }
    
    func getPerson(url: URL) async throws -> Person2 {
        let request = ResolveObjectRequest(q: url.absoluteString)
        do {
            if let response = try await perform(request).person {
                return await caches.person2.getModel(api: self, from: response)
            }
        } catch let ApiClientError.response(response, _) where response.couldntFindObject {
            throw ApiClientError.noEntityFound
        }
        throw ApiClientError.noEntityFound
    }
    
    func getPerson(username: String) async throws -> Person3 {
        let request = GetPersonDetailsRequest(
            personId: nil,
            username: username,
            sort: nil,
            page: nil,
            limit: nil,
            communityId: nil,
            savedOnly: nil
        )
        
        do {
            let response = try await perform(request)
            return await caches.person3.getModel(api: self, from: response)
        } catch let ApiClientError.response(response, _) where response.couldntFindObject {
            throw ApiClientError.noEntityFound
        }
    }
    
    func getPerson(url: URL) async throws -> Person3 {
        let person: Person2 = try await getPerson(url: url)
        return try await getPerson(id: person.id)
    }
    
    /// `filter` can be set to `.local` from 0.19.4 onwards.
    func searchPeople(
        query: String,
        page: Int = 1,
        limit: Int = 20,
        filter: ApiListingType = .all,
        sort: ApiSortType = .topAll
    ) async throws -> [Person2] {
        let request = SearchRequest(
            q: query,
            communityId: nil,
            communityName: nil,
            creatorId: nil,
            type_: .users,
            sort: sort,
            listingType: filter,
            page: page,
            limit: limit,
            postTitleOnly: false
        )
        let response = try await perform(request)
        return await caches.person2.getModels(api: self, from: response.users)
    }
    
    @discardableResult
    func blockPerson(id: Int, block: Bool, semaphore: UInt? = nil) async throws -> Person2 {
        let request = BlockPersonRequest(personId: id, block: block)
        let response = try await perform(request)
        let person = await caches.person2.getModel(api: self, from: response.personView, semaphore: semaphore)
        person.person1.blockedManager.updateWithReceivedValue(response.blocked, semaphore: semaphore)
        return person
    }
    
    @discardableResult
    func banPersonFromCommunity(
        personId: Int,
        communityId: Int,
        ban: Bool,
        removeContent: Bool,
        reason: String?,
        expires: Date? = nil
    ) async throws -> Person2 {
        let expiryTimestamp: Int?
        if let expires {
            expiryTimestamp = Int(expires.timeIntervalSince1970)
        } else {
            expiryTimestamp = nil
        }
        let request = BanFromCommunityRequest(
            communityId: communityId,
            personId: personId,
            ban: ban,
            removeData: removeContent,
            reason: reason,
            expires: expiryTimestamp
        )
        let response = try await perform(request)
        guard response.banned == ban else { throw ApiClientError.unsuccessful }
        let person = await caches.person2.getModel(api: self, from: response.personView)
        person.person1.updateKnownCommunityBanState(id: communityId, banned: response.banned)
        return person
    }
    
    @discardableResult
    func banPersonFromInstance(
        personId: Int,
        ban: Bool,
        removeContent: Bool,
        reason: String?,
        expires: Date? = nil
    ) async throws -> Person2 {
        let expiryTimestamp: Int?
        if let expires {
            expiryTimestamp = Int(expires.timeIntervalSince1970)
        } else {
            expiryTimestamp = nil
        }
        let request = BanPersonRequest(
            personId: personId,
            ban: ban,
            removeData: removeContent,
            reason: reason,
            expires: expiryTimestamp
        )
        let response = try await perform(request)
        guard response.banned == ban else { throw ApiClientError.unsuccessful }
        let person = await caches.person2.getModel(api: self, from: response.personView)
        return person
    }
    
    func purgePerson(id: Int, reason: String?) async throws {
        let request = PurgePersonRequest(personId: id, reason: reason)
        let response = try await perform(request)
        guard response.success else { throw ApiClientError.unsuccessful }
        caches.person1.retrieveModel(cacheId: id)?.purged = true
    }
    
    func getContent(
        authorId id: Int,
        sort: ApiSortType,
        page: Int,
        limit: Int,
        savedOnly: Bool? = nil,
        communityId: Int? = nil
    ) async throws -> (person: Person3, posts: [Post2], comments: [Comment2]) {
        let request = GetPersonDetailsRequest(
            personId: id,
            username: nil,
            sort: sort,
            page: page,
            limit: limit,
            communityId: nil,
            savedOnly: savedOnly
        )
        let response = try await perform(request)
        return await (
            person: caches.person3.getModel(api: self, from: response),
            posts: caches.post2.getModels(api: self, from: response.posts),
            comments: caches.comment2.getModels(api: self, from: response.comments)
        )
    }
    
    func getMyPerson() async throws -> (person: Person4?, instance: Instance3, blocks: BlockList?) {
        let request = GetSiteRequest()
        let response = try await perform(request)
        let instance = await caches.instance3.getModel(api: self, from: response)
        
        var blocks: BlockList? = self.blocks
        var person: Person4?
        if let myUser = response.myUser {
            person = await caches.person4.getModel(api: self, from: myUser)
            if let blocks {
                blocks.update(myUserInfo: myUser)
            } else {
                blocks = .init(api: self, myUserInfo: myUser)
            }
        }
        self.blocks = blocks
        myPerson = person
        myInstance = instance
        return (person: person, instance: instance, blocks: blocks)
    }
    
    func deleteAccount(password: String, deleteContent: Bool?) async throws {
        let request = DeleteAccountRequest(password: password, deleteContent: deleteContent)
        try await perform(request)
    }
    
    func editAccountSettings(
        showNsfw: Bool?,
        showScores: Bool?,
        theme: String?,
        defaultSortType: ApiSortType?,
        defaultListingType: ApiListingType?,
        interfaceLanguage: String?,
        avatar: String?,
        banner: String?,
        displayName: String?,
        email: String?,
        bio: String?,
        matrixUserId: String?,
        showAvatars: Bool?,
        sendNotificationsToEmail: Bool?,
        botAccount: Bool?,
        showBotAccounts: Bool?,
        showReadPosts: Bool?,
        discussionLanguages: [Int]?,
        openLinksInNewTab: Bool?,
        blurNsfw: Bool?,
        autoExpand: Bool?,
        infiniteScrollEnabled: Bool?,
        postListingMode: ApiPostListingMode?,
        enableKeyboardNavigation: Bool?,
        enableAnimatedImages: Bool?,
        collapseBotComments: Bool?,
        showUpvotes: Bool?,
        showDownvotes: Bool?,
        showUpvotePercentage: Bool?
    ) async throws {
        let request = SaveUserSettingsRequest(
            showNsfw: showNsfw,
            showScores: showScores,
            theme: theme,
            defaultSortType: defaultSortType,
            defaultListingType: defaultListingType,
            interfaceLanguage: interfaceLanguage,
            avatar: avatar,
            banner: banner,
            displayName: displayName,
            email: email,
            bio: bio,
            matrixUserId: matrixUserId,
            showAvatars: showAvatars,
            sendNotificationsToEmail: sendNotificationsToEmail,
            botAccount: botAccount,
            showBotAccounts: showBotAccounts,
            showReadPosts: showReadPosts,
            showNewPostNotifs: nil,
            discussionLanguages: discussionLanguages,
            generateTotp2fa: nil,
            openLinksInNewTab: openLinksInNewTab,
            blurNsfw: blurNsfw,
            autoExpand: autoExpand,
            infiniteScrollEnabled: infiniteScrollEnabled,
            postListingMode: postListingMode,
            enableKeyboardNavigation: enableKeyboardNavigation,
            enableAnimatedImages: enableAnimatedImages,
            collapseBotComments: collapseBotComments,
            showUpvotes: showUpvotes,
            showDownvotes: showDownvotes,
            showUpvotePercentage: showUpvotePercentage
        )
        let response = try await perform(request)
        guard response.success else { throw ApiClientError.unsuccessful }
    }
}
