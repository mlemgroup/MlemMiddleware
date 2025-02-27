//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-25.
//  

import Foundation
import Nuke

extension Post1: ImagePrefetchProviding {
    public func imageRequests(configuration config: PrefetchingConfiguration) async -> [ImageRequest] {
        var ret: [ImageRequest] = .init()
        
        // handle loops.video embedding
        if config.embedLoops {
            await parseLoopEmbeds()
        }
        
        switch type {
        case let .media(url), let .embedded(url, _):
            // media/embedded media: only load the media
            switch config.imageSize {
            case .unlimited:
                ret.append(ImageRequest(url: url, priority: .high))
            case let .limited(size):
                ret.append(ImageRequest(url: url.withIconSize(size), priority: .high))
            }
        case let .link(link):
            // websites: load image and favicon
            if config.fetchFavicons, let url = link.favicon {
                ret.append(ImageRequest(url: url))
            }
            if let url = link.thumbnail {
                switch config.imageSize {
                case .unlimited:
                    ret.append(ImageRequest(url: url, priority: .high))
                case let .limited(size):
                    ret.append(ImageRequest(url: url.withIconSize(size), priority: .high))
                }
            }
        default:
            break
        }
        return ret
    }
}
