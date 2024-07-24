//
//  File.swift
//  
//
//  Created by Eric Andrews on 2024-07-23.
//

import Foundation

/// Protocol for items that can be converted into a generic UserContent
public protocol UserContentProviding: FeedLoadable {
    var userContent: UserContent { get }
}
