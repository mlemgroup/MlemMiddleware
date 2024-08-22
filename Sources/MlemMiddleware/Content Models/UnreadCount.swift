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
    
    private var verifiedCount: Counts = .init()
    private var unverifiedCount: Counts = .init()
    
    public var replies: Int { verifiedCount.replies + unverifiedCount.replies }
    public var mentions: Int { verifiedCount.mentions + unverifiedCount.mentions }
    public var messages: Int { verifiedCount.messages + unverifiedCount.messages }
    
    /// This value is incremented whenever the inbox count changes due to an
    /// updated unread count being fetched from the API. It is not incremented when
    /// state-faking is performed. This can be used as a trigger to decide when to
    /// refresh the inbox.
    public private(set) var updateId: UInt = 0
    
    private var lastUpdateSemaphore: UInt = 0
    
    public var total: Int { replies + mentions + messages }
    
    internal init(api: ApiClient) {
        self.api = api
    }
    
    public func refresh() async throws {
        try await self.api.refreshUnreadCount()
    }
    
    internal func beginUpdate() {
        lastUpdateSemaphore = SemaphoreServer.next()
    }
    
    @MainActor
    internal func update(with response: ApiGetUnreadCountResponse) {
        if self.verifiedCount != .init(from: response) {
            self.verifiedCount = .init(from: response)
            updateId += 1
        }
        print("UnreadCount UPDT")
    }
    
    internal func clear() {
        self.verifiedCount = .init()
        self.unverifiedCount = .init()
    }
    
    internal func updateItem(itemType: InboxItemType, isRead: Bool, updateType: StateManagerUpdateType, semaphore: UInt?) {
        // print("SEM", isRead, semaphore, lastUpdateSemaphore)
//        if let semaphore, semaphore < lastUpdateSemaphore { return }
        let diff = isRead ? -1 : 1
        switch updateType {
        case .begin, .rollback:
            self.unverifiedCount[itemType] += diff
        case .receive:
            self.unverifiedCount[itemType] += diff
            self.verifiedCount[itemType] -= diff
        }
    }
}

// Send count
// Send mark (updates unread count)
// Server recv count, sends back
// Server recv mark, sends back
// Recv count
// Recv mark
// Count does not include updated mark

private struct Counts: Equatable {
    var replies: Int = 0
    var mentions: Int = 0
    var messages: Int = 0
}

extension Counts {
    init(from response: ApiGetUnreadCountResponse) {
        self.replies = response.replies
        self.mentions = response.mentions
        self.messages = response.privateMessages
    }
    
    public static func + (lhs: Counts, rhs: Counts) -> Counts {
        return .init(
            replies: lhs.replies + rhs.replies,
            mentions: lhs.mentions + rhs.mentions,
            messages: lhs.messages + rhs.messages
        )
    }
    
    subscript (type: InboxItemType) -> Int {
        get {
            switch type {
            case .reply: replies
            case .mention: mentions
            case .message: messages
            }
        }
        set {
            switch type {
            case .reply: replies = newValue
            case .mention: mentions = newValue
            case .message: messages = newValue
            }
        }
    }
}

internal enum InboxItemType {
    case reply, mention, message
}
