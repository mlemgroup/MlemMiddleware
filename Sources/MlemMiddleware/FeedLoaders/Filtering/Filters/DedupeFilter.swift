//
//  PostDedupeFilter.swift
//
//
//  Created by Eric Andrews on 2024-05-31.
//

import Foundation

class DedupeFilter<FilterTarget: ActorIdentifiable>: FilterProviding {
    var numFiltered: Int = 0
    private var seen: Set<ActorIdentifier> = .init()
    var active: Bool = true
    
    func filter(_ targets: [FilterTarget]) -> [FilterTarget] {
        let ret = targets.filter { seen.insert($0.actorId).inserted }
        numFiltered += targets.count - ret.count
        return ret
    }
    
    func reset(with targets: [FilterTarget]?) -> [FilterTarget] {
        numFiltered = 0
        seen = .init()
        if let targets { return filter(targets) }
        return .init()
    }
}

class InboxDedupeFilter<FilterTarget: InboxIdentifiable>: FilterProviding {
    var numFiltered: Int = 0
    private var seen: Set<Int> = .init()
    var active: Bool = true
    
    func filter(_ targets: [FilterTarget]) -> [FilterTarget] {
        let ret = targets.filter { seen.insert($0.inboxId).inserted }
        numFiltered += targets.count - ret.count
        return ret
    }
    
    func reset(with targets: [FilterTarget]?) -> [FilterTarget] {
        numFiltered = 0
        seen = .init()
        if let targets { return filter(targets) }
        return .init()
    }
}
