//
//  PreloadImages.swift
//
//
//  Created by Eric Andrews on 2024-07-07.
//

import Foundation
import Nuke

func preloadImages(
    _ newPosts: [Post2],
    smallAvatarIconSize: Int,
    largeAvatarIconSize: Int,
    urlCache: URLCache
) {
    let prefetcher: ImagePrefetcher = .init(
        pipeline: ImagePipeline.shared,
        destination: .memoryCache,
        maxConcurrentRequestCount: 40
    )
    
    URLSession.shared.configuration.urlCache = urlCache
    var imageRequests: [ImageRequest] = []
    for post in newPosts {
        // preload user and community avatars--fetching both because we don't know which we'll need, but these are super tiny
        // so it's probably not an API crime, right?
        if let communityAvatarLink = post.community.avatar {
            imageRequests.append(ImageRequest(url: communityAvatarLink.withIconSize(smallAvatarIconSize)))
        }
        
        if let userAvatarLink = post.creator.avatar {
            imageRequests.append(ImageRequest(url: userAvatarLink.withIconSize(largeAvatarIconSize * 2)))
        }
        
        switch post.type {
        case let .image(url):
            // images: only load the image
            imageRequests.append(ImageRequest(url: url, priority: .high))
        case let .link(url):
            // websites: load image and favicon
            if let baseURL = post.linkUrl?.host,
               let favIconURL = URL(string: "https://www.google.com/s2/favicons?sz=64&domain=\(baseURL)") {
                imageRequests.append(ImageRequest(url: favIconURL))
            }
            if let url {
                imageRequests.append(ImageRequest(url: url, priority: .high))
            }
        default:
            break
        }
    }
    
    prefetcher.startPrefetching(with: imageRequests)
}
