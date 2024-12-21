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
    
    init(keywords: Set<String>, moderatedCommunities: Set<URL>) {
        self.keywords = keywords
        self.moderatedCommunities = moderatedCommunities
    }
    
    func filter(_ targets: [Post2]) -> [Post2] {
        let ret = targets.filter { moderatedCommunities.contains($0.community.actorId) || !$0.title.lowercased().isContainedIn(keywords) }
        numFiltered += targets.count - ret.count
        return ret
    }
    
    func reset(with targets: [Post2]?) -> [Post2] {
        numFiltered = 0
        if let targets { return filter(targets) }
        return .init()
    }
    
    func updateModeratedCommunities(for user: Person4?) {
        print("DEBUG updating moderated communities")
        if let user {
            moderatedCommunities = user.moderatedCommunityIds
        } else {
            moderatedCommunities = .init()
        }
        print(moderatedCommunities)
    }
}
