//
//  PostType.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-14.
//

import Foundation

public enum PostType: Equatable {
    case text(String)
    case image(URL)
    case link(PostLink)
    case titleOnly
    
    public var isText: Bool {
        if case .text = self {
            return true
        }
        return false
    }
    
    public var isMedia: Bool {
        if case .image = self {
            return true
        }
        return false
    }
    
    public var isLink: Bool {
        if case .link = self {
            return true
        }
        return false
    }
}
