//
//  ContentCache.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-01.
//

import Foundation

/// Class providing caching behavior for models associated with API types
class ApiTypeBackedCache<
    Content: ApiBackedCacheIdentifiable & AnyObject & ContentModel,
    ApiType: CacheIdentifiable & Hashable
>: CoreCache<Content> {
    func getModel(api: ApiClient, from apiType: ApiType, semaphore: UInt? = nil) -> Content {
        if let item = retrieveModel(cacheId: apiType.cacheId) {
            if semaphore != nil || item.apiTypeHash != apiType.hashValue {
                item.apiTypeHash = apiType.hashValue
                updateModel(item, with: apiType, semaphore: semaphore)
            }
            return item
        }
        
        let newItem: Content = performModelTranslation(api: api, from: apiType)
        newItem.apiTypeHash = apiType.hashValue
        itemCache.put(newItem)
        return newItem
    }
    
    /// Initializes a new middleware model from the associated API type
    /// - Warning: This method DOES NOT CACHE! You almost certainly want to be using `getModel` instead.
    func performModelTranslation(api: ApiClient, from apiType: ApiType) -> Content {
        // the name of this method is intentionally unwieldy to further discourage accidental use
        preconditionFailure("This method must be overridden by the instantiating class: \(self)")
    }
    
    func updateModel(_ item: Content, with apiType: ApiType, semaphore: UInt? = nil) {
        preconditionFailure("This method must be overridden by the instantiating class: \(self)")
    }
}
