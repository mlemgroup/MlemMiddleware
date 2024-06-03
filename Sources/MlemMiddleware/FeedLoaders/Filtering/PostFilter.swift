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

class PostFilterer: MultiFilter<Post2> {
    private var readFilter: PostReadFilter
    private var dedupeFilter: PostDedupeFilter = .init()
    
    init(showRead: Bool) {
        self.readFilter = .init()
        if showRead {
            readFilter.active = false
        }
    }

    override func allFilters() -> [any FilterProviding<Post2>] {
        [
            readFilter,
            dedupeFilter
        ]
    }
    
    override func getFilter(_ toGet: OptionalPostFilters) -> any FilterProviding<Post2> {
        switch toGet {
        case .read: readFilter
        }
    }
}
