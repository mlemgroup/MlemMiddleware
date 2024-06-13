//
//  InstanceCaches.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-01.
//

import Foundation

class Instance1Cache: ApiTypeBackedCache<Instance1, ApiSite> {
    override func performModelTranslation(api: ApiClient, from apiType: ApiSite) async -> Instance1 {
        return .init(
            api: api,
            actorId: api.baseUrl,
            id: apiType.id,
            instanceId: apiType.instanceId,
            created: apiType.published,
            updated: apiType.updated,
            publicKey: apiType.publicKey,
            displayName: apiType.name,
            description: apiType.sidebar,
            shortDescription: apiType.description,
            avatar: apiType.icon,
            banner: apiType.banner,
            lastRefresh: apiType.lastRefreshedAt,
            contentWarning: apiType.contentWarning
        )
    }
    
    override func updateModel(_ item: Instance1, with apiType: ApiSite, semaphore: UInt? = nil) async {
        item.update(with: apiType)
    }
    
    /// Convenience method for getting an optional site
    func getOptionalModel(api: ApiClient, from apiType: ApiSite?) async -> Instance1? {
        if let apiType {
            return await getModel(api: api, from: apiType)
        }
        return nil
    }
}

class Instance2Cache: ApiTypeBackedCache<Instance2, ApiSiteView> {
    let instance1Cache: Instance1Cache
    
    init(instance1Cache: Instance1Cache) {
        self.instance1Cache = instance1Cache
    }
    
    override func performModelTranslation(api: ApiClient, from apiType: ApiSiteView) async -> Instance2 {
        await .init(
            api: api,
            instance1: instance1Cache.getModel(api: api, from: apiType.site),
            setup: apiType.localSite.siteSetup,
            downvotesEnabled: apiType.localSite.enableDownvotes,
            nsfwContentEnabled: apiType.localSite.enableNsfw,
            communityCreationRestrictedToAdmins: apiType.localSite.communityCreationAdminOnly,
            emailVerificationRequired: apiType.localSite.requireEmailVerification,
            applicationQuestion: apiType.localSite.applicationQuestion,
            isPrivate: apiType.localSite.privateInstance,
            defaultTheme: apiType.localSite.defaultTheme,
            defaultFeed: apiType.localSite.defaultPostListingType,
            legalInformation: apiType.localSite.legalInformation,
            hideModlogNames: apiType.localSite.hideModlogModNames,
            emailApplicationsToAdmins: apiType.localSite.applicationEmailAdmins,
            emailReportsToAdmins: apiType.localSite.reportsEmailAdmins,
            slurFilterRegex: apiType.localSite.slurFilterRegex,
            actorNameMaxLength: apiType.localSite.actorNameMaxLength,
            federationEnabled: apiType.localSite.federationEnabled,
            captchaEnabled: apiType.localSite.captchaEnabled,
            captchaDifficulty: .init(rawValue: apiType.localSite.captchaDifficulty),
            registrationMode: apiType.localSite.registrationMode,
            federationSignedFetch: apiType.localSite.federationSignedFetch,
            defaultPostListingMode: apiType.localSite.defaultPostListingMode,
            defaultSortType: apiType.localSite.defaultSortType,
            userCount: apiType.counts.users,
            postCount: apiType.counts.posts,
            commentCount: apiType.counts.comments,
            communityCount: apiType.counts.communities,
            activeUserCount: .init(
                sixMonths: apiType.counts.usersActiveHalfYear,
                month: apiType.counts.usersActiveMonth,
                week: apiType.counts.usersActiveWeek,
                day: apiType.counts.usersActiveDay
            )
        )
    }
    
    override func updateModel(_ item: Instance2, with apiType: ApiSiteView, semaphore: UInt? = nil) async {
        item.update(with: apiType)
    }
}

class Instance3Cache: ApiTypeBackedCache<Instance3, ApiGetSiteResponse> {
    let instance2Cache: Instance2Cache
    let person2Cache: Person2Cache

    init(instance2Cache: Instance2Cache, person2Cache: Person2Cache) {
        self.instance2Cache = instance2Cache
        self.person2Cache = person2Cache
    }
    
    override func performModelTranslation(api: ApiClient, from apiType: ApiGetSiteResponse) async -> Instance3 {
        await .init(
            api: api,
            instance2: instance2Cache.getModel(api: api, from: apiType.siteView),
            version: .init(apiType.version),
            allLanguages: apiType.allLanguages,
            discussionLanguages: apiType.discussionLanguages,
            taglines: apiType.taglines,
            customEmojis: apiType.customEmojis,
            blockedUrls: apiType.blockedUrls,
            administrators: apiType.admins.asyncMap { await person2Cache.getModel(api: api, from: $0) }
        )
    }
    
    override func updateModel(_ item: Instance3, with apiType: ApiGetSiteResponse, semaphore: UInt? = nil) async {
        await item.update(with: apiType)
    }
}
