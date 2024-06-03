//
//  FilterProviding.swift
//
//
//  Created by Eric Andrews on 2024-05-31.
//

import Foundation

//protocol MultiFilterProviding<FilterTarget>: FilterProviding {
//    associatedtype FilterTarget
//    associatedtype OptionalFilters
//    
//    func activate(filter: OptionalFilters) -> Bool
//    func deactivate(filter: OptionalFilters) -> Bool
//    func filteredCount(for filter: OptionalFilters) -> Int
//}

class MultiFilter<FilterTarget: FeedLoadable> {
    var numFiltered: Int { allFilters().reduce(0) { $0 + $1.numFiltered } }
    
    // MARK: core private methods
    // These methods allow overriding classes to define any individual filters they may require; provided they conform to FilterProviding<FilterTarget> and are appropriately presented via these methods, all subsequent filtering logic can be performed generically.
    
    
    /// Lists all filters in this MultiFilter. Used internally to iterate over filters and perform filtering logic. This function bridges the gap between the generic behavior, which wants a list of `[any FilterProviding<FilterTarget>]` to use in filtering, and the instantiating class, which is far more ergonomic if filters can be declared as simple member variables.
    /// - Returns: list of all filters in this MultiFilter
    private func allFilters() -> [any FilterProviding<FilterTarget>] {
        preconditionFailure("This method must be implemented by the instantiating class")
    }
    
    
    /// Gets a particular optional filter. Used internally to back the `activate`, `deactivate`, and `filteredCount` methods; as with `allFilters`, used to bridge generic and concrete behavior.
    /// - Parameter toGet: `OptionalFilters` describing the filter to get
    /// - Returns: filter corresponding to `toGet`
    private func getFilter(_ toGet: FilterTarget.OptionalFilters) -> any FilterProviding<FilterTarget> {
        preconditionFailure("This method must be implemented by the instantiating class")
    }
    
    func filter(_ targets: [FilterTarget]) -> [FilterTarget] {
        var ret: [FilterTarget] = targets
        for filter in allFilters() where filter.active {
            ret = filter.filter(ret)
        }
        return ret
    }
    
    /// Deactivates the given filter
    /// - Parameter filter: filter to deactivate
    /// - Retunrs: true if the filter was successfully deactivated, false if it was already inactive
    func reset(with targets: [FilterTarget] = .init()) -> [FilterTarget] {
        var ret = targets
        for filter in allFilters() {
            if filter.active {
                ret = filter.reset(with: ret)
            } else {
                _ = filter.reset(with: nil)
            }
        }
        return ret
    }
    
    /// Activates the given filter
    /// - Parameter filter: filter to activate
    /// - Returns: true if the filter was successfully activated, false if it was already active
    func activate(_ toActivate: FilterTarget.OptionalFilters) -> Bool {
        var filter = getFilter(toActivate)
        let ret = !filter.active
        filter.active = true
        return ret
    }
    
    /// Deactivates the given filter
    /// - Parameter filter: filter to deactivate
    /// - Retunrs: true if the filter was successfully deactivated, false if it was already inactive
    func deactivate(_ toDeactivate: FilterTarget.OptionalFilters) -> Bool {
        var filter = getFilter(toDeactivate)
        let ret = filter.active
        filter.active = false
        return ret
    }
    
    func numFiltered(for filter: FilterTarget.OptionalFilters) -> Int {
        return getFilter(filter).numFiltered
    }
}

protocol FilterProviding<FilterTarget> {
    associatedtype FilterTarget
    
    /// Given a list of `FilterTarget`s, returns all members that pass the filter and tracks how many members do not
    /// - Parameter targets: list of `FilterTarget`s to filter
    func filter(_ targets: [FilterTarget]) -> [FilterTarget]
    
    /// Clears the filter and processes all provided targets
    /// - Parameter targets: optional list of `FilterTarget`s; if present, these will be filtered and the results returned
    func reset(with targets: [FilterTarget]?) -> [FilterTarget]
    
    /// How many items this filter has caught
    var numFiltered: Int { get }
    
    var active: Bool { get set }
}
