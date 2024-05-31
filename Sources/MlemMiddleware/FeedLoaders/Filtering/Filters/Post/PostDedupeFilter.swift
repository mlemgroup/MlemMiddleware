//
//  PostDedupeFilter.swift
//
//
//  Created by Eric Andrews on 2024-05-31.
//

import Foundation

class PostDedupeFilter: FilterProviding {
    typealias FilterTarget = Post2
    
    var numFiltered: Int = 0
    private var seen: Set<URL> = .init()
    var active: Bool = true
    
    func filter(_ targets: [Post2]) -> [Post2] {
        let ret = targets.filter { seen.insert($0.actorId).inserted }
        numFiltered += targets.count - ret.count
        return ret
    }
    
    func reset(with targets: [Post2]?) -> [Post2] {
        numFiltered = 0
        seen = .init()
        if let targets { return filter(targets) }
        return .init()
    }
}
