//
//  UnreadCount.swift
//
//
//  Created by Sjmarf on 05/07/2024.
//

import Foundation

@Observable
public final class UnreadCount {
    public let api: ApiClient
    
    internal var verifiedCount: [InboxItemType: Int] = .init()
    internal var unverifiedCount: [InboxItemType: Int] = .init()
    
    public var replies: Int { self[.reply] }
    public var mentions: Int { self[.mention] }
    public var messages: Int { self[.message] }
    public var postReports: Int { self[.postReport] }
    public var commentReports: Int { self[.commentReport] }
    public var messageReports: Int { self[.messageReport] }
    public var registrationApplications: Int { self[.registrationApplication] }
    
    /// This value is incremented whenever the inbox count changes due to an
    /// updated unread count being fetched from the API. It is not incremented when
    /// state-faking is performed. This can be used as a trigger to decide when to
    /// refresh the inbox.
    public private(set) var refreshNumber: UInt = 0
    
    public var personalTotal: Int { replies + mentions + messages }
    public var reportTotal: Int { postReports + commentReports + messageReports }
    public var moderationTotal: Int { reportTotal + registrationApplications }
    public var total: Int { personalTotal + moderationTotal }
    
    internal init(api: ApiClient) {
        self.api = api
    }
    
    @MainActor
    internal func update(with newValues: [InboxItemType: Int]) {
        var shouldUpdate: Bool = false
        for (type, value) in newValues {
            if verifiedCount[type] != value {
                verifiedCount[type] = value
                shouldUpdate = true
            }
        }
        if shouldUpdate {
            refreshNumber += 1
        }
    }
    
    @MainActor
    internal func update(with sources: [any DictionaryConvertible]) {
        update(
            with: sources.reduce(into: [InboxItemType: Int](), {
                $0.merge($1.unreadCountDictionary) { $1 }
            })
        )
    }
    
    internal func clear() {
        self.verifiedCount = .init()
        self.unverifiedCount = .init()
    }
    
    internal func updateUnverifiedItem(itemType: InboxItemType, isRead: Bool) {
        let diff = isRead ? -1 : 1
        self.unverifiedCount[itemType, default: 0] += diff
    }
    
    internal func verifyItem(itemType: InboxItemType, isRead: Bool) {
        let diff = isRead ? -1 : 1
        self.verifiedCount[itemType, default: 0] += diff
        self.unverifiedCount[itemType, default: 0] -= diff
    }
    
    public subscript (_ type: InboxItemType) -> Int {
        (verifiedCount[type] ?? 0) + (unverifiedCount[type] ?? 0)
    }
    
    public func refresh() async throws {
        let values: [InboxItemType: Int] = try await withThrowingTaskGroup(
            of: [InboxItemType: Int].self,
            returning: [InboxItemType: Int].self
        ) { taskGroup in
            taskGroup.addTask {
                try await self.api.getPersonalUnreadCount().unreadCountDictionary
            }
            if self.api.myPerson == nil || self.api.myInstance == nil {
                // The theoretical solution to this is to store the moderated
                // community IDs in `ApiClient.Context` and `await` them here.
                print("Warning: ApiClient.myPerson or ApiClient.myInstance is nil at UnreadCount refresh - this may lead to unneeded API calls")
            }
            if !(self.api.myPerson?.moderatedCommunities.isEmpty ?? false) || self.api.isAdmin {
                taskGroup.addTask {
                    try await self.api.getReportCount(communityId: nil).unreadCountDictionary
                }
            }
            // Don't use `api.isAdmin` here; it falls back to `false` and we need to fallback to `true`
            if api.myInstance?.administrators.contains(where: { $0.id == api.myPerson?.id }) ?? true {
                taskGroup.addTask {
                    do {
                        return try await self.api.getRegistrationApplicationCount().unreadCountDictionary
                    } catch let ApiClientError.response(response, _) where response.error == "not_an_admin" {
                        return [:]
                    }
                }
            }
            return try await taskGroup.reduce(into: [:]) { $0.merge($1) { $1 } }
        }
        await self.update(with: values)
    }
}

public enum InboxItemType: Codable {
    case reply, mention, message
    case postReport, commentReport, messageReport, registrationApplication
}

public extension Set<InboxItemType> {
    static var all: Set<InboxItemType> {
        [.reply, .mention, .message, .postReport, .commentReport, .messageReport, .registrationApplication]
    }
    
    static var personal: Set<InboxItemType> {
        [.reply, .mention, .message]
    }
    
    static var reports: Set<InboxItemType> {
        [.postReport, .commentReport, .messageReport]
    }
    
    static var moderatorAndAdmin: Set<InboxItemType> {
        reports.union([.registrationApplication])
    }
}

internal extension UnreadCount {
    protocol DictionaryConvertible {
        var unreadCountDictionary: [InboxItemType: Int] { get }
    }
}
