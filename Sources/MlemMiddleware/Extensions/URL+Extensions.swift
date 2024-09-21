//
//  URL+Identifiable.swift
//  Mlem
//
//  Created by Nicholas Lawson on 04/06/2023.
//

import Foundation

extension URL: Identifiable {
    public var id: URL { absoluteURL }
}

public extension URL {
    // Spec described here: https://join-lemmy.org/docs/contributors/04-api.html#images
    func withIconSize(_ size: Int?) -> URL {
        guard let size else { return self }
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            print("Failed to create URLComponents")
            return self.appending(queryItems: [.init(name: "thumbnail", value: String(size))])
        }
        var queryItems = components.queryItems ?? []
        queryItems.removeFirst(where: { $0.name == "thumbnail" })
        queryItems.append(.init(name: "thumbnail", value: String(size)))
        components.queryItems = queryItems
        return components.url ?? self
    }
    
    func removingPathComponents() -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        return components.url!
    }
    
    // TODO: rename to isMedia
    var isMedia: Bool {
        pathExtension.lowercased().contains(["jpg", "jpeg", "png", "webp", "gif"])
    }
}
