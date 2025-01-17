//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-15.
//  

import Foundation

extension ApiGetReportCountResponse: UnreadCount.DictionaryConvertible {
    internal var unreadCountDictionary: [InboxItemType : Int] {
        [
            .postReport: postReports,
            .commentReport: commentReports,
            .messageReport: privateMessageReports ?? 0
        ]
    }
}
