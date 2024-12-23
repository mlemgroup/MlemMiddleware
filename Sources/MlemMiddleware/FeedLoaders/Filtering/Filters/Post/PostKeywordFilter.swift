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
    private var keywords: Set<String>
    private var moderatedCommunities: Set<URL>
    var active: Bool = true
    
    init(context: FilterContext) {
        self.keywords = context.filteredKeywords
        self.moderatedCommunities = context.moderatedCommunityIds
    }
    
    func filter(_ targets: [Post2]) -> [Post2] {
        let ret = targets.filter { shouldPassFilter($0) }
        numFiltered += targets.count - ret.count
        return ret
    }
    
    func reset(with targets: [Post2]?) -> [Post2] {
        numFiltered = 0
        if let targets { return filter(targets) }
        return .init()
    }
    
    /// Returns true if the given post should pass the filter, false otherwise
    public func shouldPassFilter(_ post: Post2) -> Bool {
        moderatedCommunities.contains(post.community.actorId) ||
        !post.title.lowercased().containsWordsIn(keywords)
    }
    
    func updateFilterContext(to context: FilterContext) {
        keywords = context.filteredKeywords
        moderatedCommunities = context.moderatedCommunityIds
    }
}
