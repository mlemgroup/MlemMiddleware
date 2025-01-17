//
//  ApiGetUnreadCountResponse+Extensions.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-15.
//  

import Foundation

extension ApiGetUnreadCountResponse: UnreadCount.DictionaryConvertible {
    internal var unreadCountDictionary: [InboxItemType : Int] {
        [
            .reply: replies,
            .mention: mentions,
            .message: privateMessages
        ]
    }
}
