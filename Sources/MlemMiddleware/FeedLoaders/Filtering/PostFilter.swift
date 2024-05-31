//
//  PostFilter.swift
//
//
//  Created by Eric Andrews on 2024-05-31.
//

import Foundation

enum OptionalFilters {
    case read
}

class PostFilterer: FilterProviding {
    typealias FilterTarget = Post2
    
    var numFiltered: Int { allFilters.reduce(0) { $0 + $1.numFiltered } }
    var active: Bool = true
    
    private var readFilter: PostReadFilter = .init()
    private var dedupeFilter: PostDedupeFilter = .init()
    
    private var allFilters: [any FilterProviding<Post2>] { [
        readFilter,
        dedupeFilter
    ] }
    
    func filter(_ targets: [Post2]) -> [Post2] {
        var ret: [Post2] = targets
        for filter in allFilters where filter.active {
            ret = filter.filter(ret)
        }
        return ret
    }
    
    func reset(with targets: [Post2]?) -> [Post2] {
        var ret: [Post2] = targets ?? .init()
        for filter in allFilters {
            if filter.active {
                ret = filter.reset(with: targets)
            } else {
                _ = filter.reset(with: nil)
            }
        }
        return ret
    }
    
    func activate(filter: OptionalFilters) {
        // TODO: this needs to reset everything!
        switch filter {
        case .read:
            readFilter.active = true
        }
    }
}
