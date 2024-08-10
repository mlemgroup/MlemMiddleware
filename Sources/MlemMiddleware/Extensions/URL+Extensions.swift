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
        return appending(queryItems: [URLQueryItem(name: "thumbnail", value: "\(size)")])
    }
    
    func removingPathComponents() -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        return components.url!
    }
    
    var isImage: Bool {
        pathExtension.lowercased().contains(["jpg", "jpeg", "png", "webp"])
    }
}
