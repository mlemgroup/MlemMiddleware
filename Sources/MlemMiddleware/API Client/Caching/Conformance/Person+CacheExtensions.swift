//
//  Person+CacheExtensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-02.
//

import Foundation

extension Person1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with person: ApiPerson, semaphore: UInt? = nil) {
        setIfChanged(\.updated, person.updated)
        setIfChanged(\.displayName, person.displayName ?? person.name)
        setIfChanged(\.description, person.bio)
        setIfChanged(\.avatar, person.avatar)
        setIfChanged(\.banner, person.banner)
        
        setIfChanged(\.deleted, person.deleted)
        setIfChanged(\.isBot, person.botAccount)
        
        let newInstanceBan: InstanceBanType
        if person.banned {
            if let expires = person.banExpires {
                newInstanceBan = .temporarilyBanned(expires: expires)
            } else {
                newInstanceBan = .permanentlyBanned
            }
        } else {
            newInstanceBan = .notBanned
        }
        setIfChanged(\.instanceBan, newInstanceBan)
    }
}

extension Person2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with apiType: any Person2ApiBacker, semaphore: UInt? = nil) {
        setIfChanged(\.postCount, apiType.counts.postCount)
        setIfChanged(\.commentCount, apiType.counts.commentCount)
        person1.update(with: apiType.person, semaphore: semaphore)
    }
}

extension Person3: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(moderatedCommunities: [Community1], person2ApiBacker: any Person2ApiBacker, semaphore: UInt? = nil) {
        setIfChanged(\.self.moderatedCommunities, moderatedCommunities)
        person2.update(with: person2ApiBacker, semaphore: semaphore)
    }
}

extension Person4: CacheIdentifiable {
    public var cacheId: Int { id }
    
    func update(with apiMyUserInfo: ApiMyUserInfo, semaphore: UInt? = nil) {
        let moderates = apiMyUserInfo.moderates.map { moderatorView in
            api.caches.community1.performModelTranslation(api: api, from: moderatorView.community)
        }
        person3.update(
            moderatedCommunities: moderates,
            person2ApiBacker: apiMyUserInfo.localUserView,
            semaphore: semaphore
        )
    }
}

