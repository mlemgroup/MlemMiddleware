//
//  PostLink.swift
//
//
//  Created by Eric Andrews on 2024-07-30.
//

import Foundation

public struct PostLink: Equatable {
    public let content: URL
    public let thumbnail: URL?
    public let label: String
    var favicon: URL? {
        if let baseUrl = content.host {
            return URL(string: "https://www.google.com/s2/favicons?sz=64&domain=\(baseUrl)")
        }
        return nil
    }
}
