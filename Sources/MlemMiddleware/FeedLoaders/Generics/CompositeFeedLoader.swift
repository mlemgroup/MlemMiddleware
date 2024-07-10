//
//  CompositeFeedLoader.swift
//
//
//  Created by Eric Andrews on 2024-07-09.
//

import Foundation

protocol CompositeFeedLoadable: FeedLoadable {
    associatedtype Subtypes: CaseIterable, Hashable
    
    /// Converts from parent type to given subtype; if not that subtype, returns nil
    func asSubtype(_ subtype: Subtypes) -> (any FeedLoadable)?
}

protocol CompositeFeedStream {
    associatedtype ParentType: CompositeFeedLoadable
    associatedtype Item
    
    /// Which subtype this stream is
    var type: ParentType.Subtypes { get }
    
    /// Array of references to the actual item type
    var items: [Item] { get set }
    
    /// Current location in the stream
    var cursor: Int { get }
    
    /// Loading threshold for this item type (items.count - offset)
    var threshold: Int { get }
}

extension CompositeFeedStream {
    /// Given an array of new items of the parent type, incorporates all those items that are this type
    mutating func incorporate(newItems: [ParentType]) {
        var accepted: [Item] = newItems.compactMap { $0.asSubtype(type) as? Item }
        
        items.append(contentsOf: accepted)
        
        // TODO: update thresholds
    }
}

class CompositeFeedLoader<Item: CompositeFeedLoadable> {
    var streams: [Item.Subtypes : any CompositeFeedStream] = .init()
}
