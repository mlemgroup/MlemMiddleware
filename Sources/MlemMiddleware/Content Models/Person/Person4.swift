//
//  Person4.swift
//
//
//  Created by Sjmarf on 20/05/2024.
//

import Foundation
import Observation

@Observable
public final class Person4: Person4Providing {
    public static let tierNumber: Int = 4
    public var api: ApiClient
    public var person4: Person4 { self }

    public let person3: Person3
    
    public internal(set) var isAdmin: Bool?
    public internal(set) var voteDisplayMode: ApiLocalUserVoteDisplayMode?
    public internal(set) var email: String?
    public internal(set) var showNsfw: Bool
    public internal(set) var theme: String
    public internal(set) var defaultSortType: ApiSortType
    public internal(set) var defaultListingType: ApiListingType
    public internal(set) var interfaceLanguage: String
    public internal(set) var showAvatars: Bool
    public internal(set) var sendNotificationsToEmail: Bool
    public internal(set) var showScores: Bool
    public internal(set) var showBotAccounts: Bool
    public internal(set) var showReadPosts: Bool
    public internal(set) var showNewPostNotifs: Bool?
    public internal(set) var emailVerified: Bool
    public internal(set) var acceptedApplication: Bool
    public internal(set) var openLinksInNewTab: Bool?
    public internal(set) var blurNsfw: Bool?
    public internal(set) var autoExpandImages: Bool?
    public internal(set) var infiniteScrollEnabled: Bool?
    public internal(set) var postListingMode: ApiPostListingMode?
    public internal(set) var totp2faEnabled: Bool?
    public internal(set) var enableKeyboardNavigation: Bool?
    public internal(set) var enableAnimatedImages: Bool?
    public internal(set) var collapseBotComments: Bool?
    
    internal init(
        api: ApiClient,
        person3: Person3,
        isAdmin: Bool?,
        voteDisplayMode: ApiLocalUserVoteDisplayMode?,
        email: String?,
        showNsfw: Bool,
        theme: String,
        defaultSortType: ApiSortType,
        defaultListingType: ApiListingType,
        interfaceLanguage: String,
        showAvatars: Bool,
        sendNotificationsToEmail: Bool,
        showScores: Bool,
        showBotAccounts: Bool,
        showReadPosts: Bool,
        showNewPostNotifs: Bool?,
        emailVerified: Bool,
        acceptedApplication: Bool,
        openLinksInNewTab: Bool?,
        blurNsfw: Bool?,
        autoExpandImages: Bool?,
        infiniteScrollEnabled: Bool?,
        postListingMode: ApiPostListingMode?,
        totp2faEnabled: Bool?,
        enableKeyboardNavigation: Bool?,
        enableAnimatedImages: Bool?,
        collapseBotComments: Bool?
    ) {
        self.api = api
        self.person3 = person3
        self.isAdmin = isAdmin
        self.voteDisplayMode = voteDisplayMode
        self.email = email
        self.showNsfw = showNsfw
        self.theme = theme
        self.defaultSortType = defaultSortType
        self.defaultListingType = defaultListingType
        self.interfaceLanguage = interfaceLanguage
        self.showAvatars = showAvatars
        self.sendNotificationsToEmail = sendNotificationsToEmail
        self.showScores = showScores
        self.showBotAccounts = showBotAccounts
        self.showReadPosts = showReadPosts
        self.showNewPostNotifs = showNewPostNotifs
        self.emailVerified = emailVerified
        self.acceptedApplication = acceptedApplication
        self.openLinksInNewTab = openLinksInNewTab
        self.blurNsfw = blurNsfw
        self.autoExpandImages = autoExpandImages
        self.infiniteScrollEnabled = infiniteScrollEnabled
        self.postListingMode = postListingMode
        self.totp2faEnabled = totp2faEnabled
        self.enableKeyboardNavigation = enableKeyboardNavigation
        self.enableAnimatedImages = enableAnimatedImages
        self.collapseBotComments = collapseBotComments
    }
    
    public func upgrade() async throws -> any Person { self }
    
    public func updateSettings(
        email: String? = nil,
        matrixId: String? = nil,
        showNsfw: Bool? = nil,
        blurNsfw: Bool? = nil,
        showBotAccounts: Bool? = nil,
        sendNotificationsToEmail: Bool? = nil,
        isBot: Bool? = nil
    ) async throws {
        // iirc previous lemmy versions had issues with supplying `nil` for certain setting values.
        // I don't remember which versions this happened on or which parameters couldn't be `nil`.
        // Supplying them all to be safe.
        try await api.editAccountSettings(
            showNsfw: showNsfw ?? self.showNsfw,
            showScores: self.showScores,
            theme: self.theme,
            defaultSortType: self.defaultSortType,
            defaultListingType: self.defaultListingType,
            interfaceLanguage: self.interfaceLanguage,
            avatar: self.avatar?.absoluteString ?? "",
            banner: self.banner?.absoluteString ?? "",
            displayName: self.displayName,
            email: email ?? self.email,
            bio: self.description,
            matrixUserId: matrixId ?? self.matrixId,
            showAvatars: self.showAvatars,
            sendNotificationsToEmail: sendNotificationsToEmail ?? self.sendNotificationsToEmail,
            botAccount: isBot ?? self.isBot,
            showBotAccounts: showBotAccounts ?? self.showBotAccounts,
            showReadPosts: self.showReadPosts,
            discussionLanguages: nil,
            openLinksInNewTab: self.openLinksInNewTab,
            blurNsfw: blurNsfw ?? self.blurNsfw,
            autoExpand: self.autoExpandImages,
            infiniteScrollEnabled: self.infiniteScrollEnabled,
            postListingMode: self.postListingMode,
            enableKeyboardNavigation: self.enableKeyboardNavigation,
            enableAnimatedImages: self.enableAnimatedImages,
            collapseBotComments: self.collapseBotComments,
            showUpvotes: self.voteDisplayMode?.upvotes,
            showDownvotes: self.voteDisplayMode?.downvotes,
            showUpvotePercentage: self.voteDisplayMode?.upvotePercentage
        )
        self.email = email ?? self.email
        self.person1.matrixId = matrixId ?? self.matrixId
        self.showNsfw = showNsfw ?? self.showNsfw
        self.blurNsfw = blurNsfw ?? self.blurNsfw
        self.showBotAccounts = showBotAccounts ?? self.showBotAccounts
        self.sendNotificationsToEmail = sendNotificationsToEmail ?? self.sendNotificationsToEmail
        self.person1.isBot = isBot ?? self.isBot
    }
    
    public func updateProfile(
        displayName: String?,
        description: String?,
        avatar: URL?,
        banner: URL?
    ) async throws {
        try await api.editAccountSettings(
            showNsfw: self.showNsfw,
            showScores: self.showScores,
            theme: self.theme,
            defaultSortType: self.defaultSortType,
            defaultListingType: self.defaultListingType,
            interfaceLanguage: self.interfaceLanguage,
            avatar: avatar?.absoluteString ?? "",
            banner: banner?.absoluteString ?? "",
            displayName: displayName ?? "",
            email: self.email,
            bio: description ?? "",
            matrixUserId: self.matrixId,
            showAvatars: self.showAvatars,
            sendNotificationsToEmail: self.sendNotificationsToEmail,
            botAccount: self.isBot,
            showBotAccounts: self.showBotAccounts,
            showReadPosts: self.showReadPosts,
            discussionLanguages: nil,
            openLinksInNewTab: self.openLinksInNewTab,
            blurNsfw: self.blurNsfw,
            autoExpand: self.autoExpandImages,
            infiniteScrollEnabled: self.infiniteScrollEnabled,
            postListingMode: self.postListingMode,
            enableKeyboardNavigation: self.enableKeyboardNavigation,
            enableAnimatedImages: self.enableAnimatedImages,
            collapseBotComments: self.collapseBotComments,
            showUpvotes: self.voteDisplayMode?.upvotes,
            showDownvotes: self.voteDisplayMode?.downvotes,
            showUpvotePercentage: self.voteDisplayMode?.upvotePercentage
        )
        self.person1.displayName = displayName ?? self.name
        self.person1.description = description
        self.person1.avatar = avatar
        self.person1.banner = banner
    }
}
