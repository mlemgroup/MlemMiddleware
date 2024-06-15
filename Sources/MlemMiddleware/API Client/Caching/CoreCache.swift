//
//  CoreCache.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-01.
//

import Foundation

/// Class providing common caching behavior
open class CoreCache<Content: CacheIdentifiable & AnyObject> {
    public var cachedItems: Atomic<[Int: WeakReference<Content>]>
    
    public init() {
        self.cachedItems = .init(.init())
    }
    
    /// Retrieves the cached model with the given cacheId, if present
    /// - Parameter cacheId: cacheId of the model to retrieve
    /// - Returns: cached model if present, nil otherwise
    public func retrieveModel(cacheId: Int) -> Content? {
        cachedItems.value[cacheId]?.content
    }
    
    /// Remove dead references
    public func clean() {
        for (key, value) in cachedItems.value where value.content == nil {
            print("Removed value with id \(key)")
            cachedItems.value[key] = nil
        }
    }
}
