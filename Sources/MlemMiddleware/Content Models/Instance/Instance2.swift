//
//  Instance2.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation
import Observation

@Observable
public final class Instance2: Instance2Providing {
    public var api: ApiClient
    public var instance2: Instance2 { self }
    
    public let instance1: Instance1
    
    public var setup: Bool
    public var downvotesEnabled: Bool
    public var nsfwContentEnabled: Bool
    public var communityCreationRestrictedToAdmins: Bool
    public var emailVerificationRequired: Bool
    public var applicationQuestion: String?
    public var `private`: Bool
    public var defaultTheme: String
    public var defaultFeed: ApiListingType
    public var legalInformation: String?
    public var hideModlogNames: Bool
    public var emailApplicationsToAdmins: Bool
    public var emailReportsToAdmins: Bool
    public var slurFilterRegex: String?
    public var actorNameMaxLength: Int
    public var federationEnabled: Bool
    public var captchaEnabled: Bool
    public var captchaDifficulty: CaptchaDifficulty?
    public var registrationMode: ApiRegistrationMode
    public var federationSignedFetch: Bool?
    public var defaultPostListingMode: ApiPostListingMode?
    public var defaultSortType: ApiSortType?
    
    public var userCount: Int
    public var postCount: Int
    public var commentCount: Int
    public var communityCount: Int
    // public var activeUserCount

    internal init(api: ApiClient, instance1: Instance1) {
        self.api = api
        self.instance1 = instance1
    }
}
