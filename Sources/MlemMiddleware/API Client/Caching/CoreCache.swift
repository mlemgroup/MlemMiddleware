//
//  CoreCache.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-01.
//

import Foundation

/// Class providing common caching behavior
open class CoreCache<Content: CacheIdentifiable & AnyObject> {
    private var itemCache: ItemCache = .init()
    
    // Rather than making CoreCache an Actor, we define an internal Actor to handle the actual data; this allows CoreCache to be inherited from, since Actors do not support inheritance.
    private actor ItemCache {
        private var cachedItems: [Int: WeakReference<Content>] = .init()
        
        public func get(_ cacheId: Int) -> Content? {
            cachedItems[cacheId]?.content
        }
        
        public func put(_ model: Content) {
            cachedItems[model.cacheId] = .init(content: model)
        }
        
        public func updateCacheId(oldCacheId: Int, newCacheId: Int) {
            cachedItems[newCacheId] = cachedItems[oldCacheId]
            cachedItems[oldCacheId] = nil
        }
        
        public func clean() {
            for (key, value) in cachedItems where value.content == nil {
                print("Removed value with id \(key)")
                cachedItems[key] = nil
            }
        }
    }
    
    public init() {
        self.itemCache = .init()
    }
    
    /// Adds a weak reference to the given model to the item cache
    public func put(_ model: Content) async {
        await itemCache.put(model)
    }
    
    /// Retrieves the cached model with the given cacheId, if present
    /// - Parameter cacheId: cacheId of the model to retrieve
    /// - Returns: cached model if present, nil otherwise
    public func get(_ cacheId: Int) async -> Content? {
        await itemCache.get(cacheId)
    }
    
    public func updateCacheId(oldCacheId: Int, newCacheId: Int) async {
        await itemCache.updateCacheId(oldCacheId: oldCacheId, newCacheId: newCacheId)
    }
    
    /// Remove dead references
    public func clean() async {
        await itemCache.clean()
    }
}
