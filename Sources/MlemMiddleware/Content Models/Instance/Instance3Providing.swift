//
//  Instance3Providing.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public protocol Instance3Providing: Instance2Providing {
    var instance3: Instance3 { get }
    
    var version: SiteVersion { get }
    var allLanguages: [ApiLanguage] { get }
    var discussionLanguages: [Int] { get }
    var taglines: [ApiTagline] { get }
    var customEmojis: [ApiCustomEmojiView] { get }
    var blockedUrls: [ApiLocalSiteUrlBlocklist]? { get }
    var administrators: [Person2] { get }
    
    func addAdmin(personId: Int, added: Bool) async throws
}

public extension Instance3Providing {
    var instance2: Instance2 { instance3.instance2 }
    
    var version: SiteVersion { instance3.version }
    var allLanguages: [ApiLanguage] { instance3.allLanguages }
    var discussionLanguages: [Int] { instance3.discussionLanguages }
    var taglines: [ApiTagline] { instance3.taglines }
    var customEmojis: [ApiCustomEmojiView] { instance3.customEmojis }
    var blockedUrls: [ApiLocalSiteUrlBlocklist]? { instance3.blockedUrls }
    var administrators: [Person2] { instance3.administrators }
    
    var version_: SiteVersion? { instance3.version }
    var allLanguages_: [ApiLanguage]? { instance3.allLanguages }
    var discussionLanguages_: [Int]? { instance3.discussionLanguages }
    var taglines_: [ApiTagline]? { instance3.taglines }
    var customEmojis_: [ApiCustomEmojiView]? { instance3.customEmojis }
    var blockedUrls_: [ApiLocalSiteUrlBlocklist]? { instance3.blockedUrls }
    var administrators_: [Person2]? { instance3.administrators }
}
