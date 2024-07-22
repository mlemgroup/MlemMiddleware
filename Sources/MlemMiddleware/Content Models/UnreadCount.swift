//
//  UnreadCount.swift
//
//
//  Created by Sjmarf on 05/07/2024.
//

import Foundation

@Observable
public final class UnreadCount {
    // I haven't properly stress-tested this stake-faking system just yet.
    // There is probably a failure case when an unread count update happens
    // at the same time as a stake-fake, causing an `UnreadCount` value to be
    // incorrect. This can probably be fixed using some sort of semaphore
    // system. I think it's fine to leave this out of the first beta in the
    // interest of time but will properly implement it sometime down the road.
    // If the bug happens, it will resolve itself in 30s when the next inbox
    // count is fetched.
    
    public let api: ApiClient
    
    public internal(set) var replies: Int = 0
    public internal(set) var mentions: Int = 0
    public internal(set) var messages: Int = 0
    
    /// This value is incremented whenever the inbox count changes due to an
    /// updated unread count being fetched from the API. It is not incremented when
    /// state-faking is performed. This can be used as a trigger to decide  when to
    /// refresh the inbox.
    public private(set) var updateId: Int = 0
    
    public var total: Int { replies + mentions + messages }
    
    internal init(api: ApiClient) {
        self.api = api
    }
    
    public func refresh() async throws {
        try await self.api.refreshUnreadCount()
    }
    
    @MainActor
    internal func update(with response: ApiGetUnreadCountResponse) {
        if [
            self.replies, self.mentions, self.messages
        ] != [
            response.replies, response.mentions, response.privateMessages
        ] {
            updateId += 1
        }
        self.replies = response.replies
        self.mentions = response.mentions
        self.messages = response.privateMessages
    }
    
    internal func clear() {
        self.replies = 0
        self.mentions = 0
        self.messages = 0
    }
}
