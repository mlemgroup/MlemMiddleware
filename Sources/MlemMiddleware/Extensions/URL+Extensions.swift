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
    
    /// Path extension of this URL, taking into account image proxy behavior
    var proxyAwarePathExtension: String? {
        var ret = pathExtension
        
        // image proxies that use url query param don't have pathExtension so we extract it from the embedded url
        if ret.isEmpty,
           let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
           let queryItems = components.queryItems,
           let baseUrlString = queryItems.first(where: { $0.name == "url" })?.value,
           let baseUrl = URL(string: baseUrlString) {
            ret = baseUrl.pathExtension
        }
        
        return ret.isEmpty ? nil : ret.lowercased()
    }
    
    var isMedia: Bool {
        proxyAwarePathExtension?.isContainedIn(["jpg", "jpeg", "png", "webp", "gif", "mp4"]) ?? false
    }
}
