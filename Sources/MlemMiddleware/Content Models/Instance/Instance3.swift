//
//  Instance3.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation
import Observation

@Observable
public final class Instance3: Instance3Providing {
    public static let tierNumber: Int = 3
    public var api: ApiClient
    public var instance3: Instance3 { self }
    
    public let instance2: Instance2
    
    public var version: SiteVersion
    
    public let allLanguages: [Locale.Language]
    
    // This excludes the "undetermined" language identifier (which is 0),
    // because its presence or absence doesn't actually affect whether you're
    // able to create a post with "undetermined" as the language
    public var allowedLanguageIds: Set<Int>
    
    public var taglines: [ApiTagline]
    public var customEmojis: [ApiCustomEmojiView]
    public var blockedUrls: [ApiLocalSiteUrlBlocklist]?
    public var administrators: [Person2]
  
    internal init(
        api: ApiClient,
        instance2: Instance2,
        version: SiteVersion,
        allLanguages: [Locale.Language],
        allowedLanguageIds: Set<Int>,
        taglines: [ApiTagline],
        customEmojis: [ApiCustomEmojiView],
        blockedUrls: [ApiLocalSiteUrlBlocklist]?,
        administrators: [Person2]
    ) {
        self.api = api
        self.instance2 = instance2
        self.version = version
        self.allLanguages = allLanguages
        self.allowedLanguageIds = allowedLanguageIds
        self.taglines = taglines
        self.customEmojis = customEmojis
        self.blockedUrls = blockedUrls
        self.administrators = administrators
    }
}
