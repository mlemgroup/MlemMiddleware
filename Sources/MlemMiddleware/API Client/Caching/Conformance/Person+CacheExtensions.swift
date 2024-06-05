//
//  Person+CacheExtensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-02.
//

import Foundation

extension Person1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with person: ApiPerson) {
        updated = person.updated
        displayName = person.displayName ?? person.name
        description = person.bio
        avatar = person.avatar
        banner = person.banner
        
        deleted = person.deleted
        isBot = person.botAccount
        
        if person.banned {
            if let expires = person.banExpires {
                instanceBan = .temporarilyBanned(expires: expires)
            } else {
                instanceBan = .permanentlyBanned
            }
        } else {
            instanceBan = .notBanned
        }
    }
}

extension Person2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with apiType: any Person2ApiBacker) {
        postCount = apiType.counts.postCount
        commentCount = apiType.counts.commentCount
        person1.update(with: apiType.person)
    }
}

extension Person3: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(moderatedCommunities: [Community1], person2ApiBacker: any Person2ApiBacker) {
        self.moderatedCommunities = moderatedCommunities
        person2.update(with: person2ApiBacker)
    }
}

extension Person4: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with apiMyUserInfo: ApiMyUserInfo) {
        let moderates = apiMyUserInfo.moderates.map { moderatorView in
            api.caches.community1.performModelTranslation(api: api, from: moderatorView.community)
        }
        person3.update(
            moderatedCommunities: moderates,
            person2ApiBacker: apiMyUserInfo.localUserView
        )
    }
}

