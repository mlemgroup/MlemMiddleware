//
//  Instance+CacheExtensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-02.
//

import Foundation

extension Instance1Providing {
    public var cacheId: Int { id }
    
    internal var apiTypeHash: Int {
        get { instance1.apiTypeHash }
        set { instance1.apiTypeHash = newValue }
    }
}

extension Instance1: ApiBackedCacheIdentifiable {
    func update(with site: ApiSite) {
        displayName = site.name
        description = site.sidebar
        shortDescription = site.description
        avatar = site.icon
        banner = site.banner
        lastRefresh = site.lastRefreshedAt
        contentWarning = site.contentWarning
    }
}

extension Instance2: ApiBackedCacheIdentifiable {
    func update(with siteView: ApiSiteView) {
        instance1.update(with: siteView.site)
        
        setup = siteView.localSite.siteSetup
        downvotesEnabled = siteView.localSite.enableDownvotes
        nsfwContentEnabled = siteView.localSite.enableNsfw
        communityCreationRestrictedToAdmins = siteView.localSite.communityCreationAdminOnly
        emailVerificationRequired = siteView.localSite.requireEmailVerification
        applicationQuestion = siteView.localSite.applicationQuestion
        isPrivate = siteView.localSite.privateInstance
        defaultTheme = siteView.localSite.defaultTheme
        defaultFeed = siteView.localSite.defaultPostListingType
        legalInformation = siteView.localSite.legalInformation
        hideModlogNames = siteView.localSite.hideModlogModNames
        emailApplicationsToAdmins = siteView.localSite.applicationEmailAdmins
        emailReportsToAdmins = siteView.localSite.reportsEmailAdmins
        slurFilterRegex = siteView.localSite.slurFilterRegex
        actorNameMaxLength = siteView.localSite.actorNameMaxLength
        federationEnabled = siteView.localSite.federationEnabled
        captchaEnabled = siteView.localSite.captchaEnabled
        captchaDifficulty = .init(rawValue: siteView.localSite.captchaDifficulty)
        registrationMode = siteView.localSite.registrationMode
        federationSignedFetch = siteView.localSite.federationSignedFetch
        defaultPostListingMode = siteView.localSite.defaultPostListingMode
        defaultSortType = siteView.localSite.defaultSortType
        userCount = siteView.counts.users
        postCount = siteView.counts.posts
        commentCount = siteView.counts.comments
        communityCount = siteView.counts.communities
        activeUserCount = .init(
            sixMonths: siteView.counts.usersActiveHalfYear,
            month: siteView.counts.usersActiveMonth,
            week: siteView.counts.usersActiveWeek,
            day: siteView.counts.usersActiveDay
        )
    }
}

extension Instance3: ApiBackedCacheIdentifiable {
    func update(with response: ApiGetSiteResponse) {
        version = SiteVersion(response.version)
        instance2.update(with: response.siteView)
        allLanguages = response.allLanguages
        discussionLanguages = response.discussionLanguages
        taglines = response.taglines
        customEmojis = response.customEmojis
        blockedUrls = response.blockedUrls
        administrators = response.admins.map { api.caches.person2.getModel(api: api, from: $0) }
    }
}
