//
//  PostKeywordFilter.swift
//
//
//  Created by Eric Andrews on 2024-06-02.
//

import Foundation

class PostKeywordFilter: FilterProviding {
    typealias FilterTarget = Post2
    
    var numFiltered: Int = 0
    private var keywords: [String]
    var active: Bool = true
    
    init(keywords: [String]) {
        self.keywords = keywords
    }
    
    func filter(_ targets: [Post2]) -> [Post2] {
        let ret = targets.filter { !$0.title.lowercased().contains(keywords) }
        numFiltered += targets.count - ret.count
        return ret
    }
    
    func reset(with targets: [Post2]?) -> [Post2] {
        numFiltered = 0
        if let targets { return filter(targets) }
        return .init()
    }
}
