//
//  PostFilter.swift
//
//
//  Created by Eric Andrews on 2024-05-31.
//

import Foundation

public enum OptionalPostFilters {
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
    
    private func getFilter(_ filter: OptionalPostFilters) -> any FilterProviding<Post2> {
        switch filter {
        case .read: readFilter
        }
    }
    
    /// Activates the given filter
    /// - Parameter filter: filter to activate
    /// - Returns: true if the filter was successfully activated, false if it was already active
    func activate(filter: OptionalPostFilters) -> Bool {
        var filter = getFilter(filter)
        let ret = !filter.active
        filter.active = true
        return ret
    }
    
    /// Deactivates the given filter
    /// - Parameter filter: filter to deactivate
    /// - Retunrs: true if the filter was successfully deactivated, false if it was already inactive
    func deactivate(filter: OptionalPostFilters) -> Bool {
        var filter = getFilter(filter)
        let ret = filter.active
        filter.active = false
        return ret
    }
    
    func filteredCount(for filter: OptionalPostFilters) -> Int {
        return getFilter(filter).numFiltered
    }
}
