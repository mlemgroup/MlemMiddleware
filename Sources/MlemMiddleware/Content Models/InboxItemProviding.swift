//
//  InboxItemProviding.swift
//
//
//  Created by Sjmarf on 05/07/2024.
//

import Foundation

public protocol InboxItemProviding: ContentIdentifiable, ContentModel {
    var created: Date { get }
    var read: Bool { get }
    
    func updateRead(_ newValue: Bool)
}

public extension InboxItemProviding {
    func toggleRead() {
        updateRead(!read)
    }
}
