//
//  PersonCaches.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-03-01.
//

import Foundation

class Person1Cache: ApiTypeBackedCache<Person1, ApiPerson> {
    override func performModelTranslation(api: ApiClient, from apiType: ApiPerson) -> Person1 {
        let instanceBan: InstanceBanType
        if apiType.banned {
            if let expires = apiType.banExpires {
                instanceBan = .temporarilyBanned(expires: expires)
            } else {
                instanceBan = .permanentlyBanned
            }
        } else {
            instanceBan = .notBanned
        }
        
        return .init(
            api: api,
            actorId: apiType.actorId,
            id: apiType.id,
            name: apiType.name,
            created: apiType.published,
            updated: apiType.updated,
            displayName: apiType.displayName ?? apiType.name,
            description: apiType.bio,
            matrixId: apiType.matrixUserId,
            avatar: apiType.avatar,
            banner: apiType.banner,
            deleted: apiType.deleted,
            isBot: apiType.botAccount,
            instanceBan: instanceBan,
            blocked: false // TODO: can we know this?
        )
    }
    
    override func updateModel(_ item: Person1, with apiType: ApiPerson, semaphore: UInt? = nil) {
        item.update(with: apiType)
    }
}

// Person2 can be created from any Person2ApiBacker, so we can't use ApiTypeBackedCache
class Person2Cache: CoreCache<Person2> {
    let person1Cache: Person1Cache
    
    init(person1Cache: Person1Cache) {
        self.person1Cache = person1Cache
    }

    func getModel(api: ApiClient, from apiType: any Person2ApiBacker) -> Person2 {
        if let item = retrieveModel(cacheId: apiType.cacheId) {
            item.update(with: apiType)
            return item
        }
        
        let newItem: Person2 = .init(
            api: api,
            person1: person1Cache.getModel(api: api, from: apiType.person),
            postCount: apiType.counts.postCount,
            commentCount: apiType.counts.commentCount
        )
        itemCache.put(newItem)
        return newItem
    }
}

// Person3 can be created from any Person3ApiBacker, so can't use ApiTypeBackedCache
class Person3Cache: CoreCache<Person3> {
    let person2Cache: Person2Cache
    let community1Cache: Community1Cache
    let instance1Cache: Instance1Cache
    
    init(person2Cache: Person2Cache, community1Cache: Community1Cache, instance1Cache: Instance1Cache) {
        self.person2Cache = person2Cache
        self.community1Cache = community1Cache
        self.instance1Cache = instance1Cache
    }
    
    func getModel(api: ApiClient, from apiType: any Person3ApiBacker) -> Person3 {
        let moderatedCommunities = apiType.moderates.map { moderatedCommunity in
            community1Cache.getModel(api: api, from: moderatedCommunity.community)
        }
        
        if let item = retrieveModel(cacheId: apiType.cacheId) {
            item.update(moderatedCommunities: moderatedCommunities, person2ApiBacker: apiType.person2ApiBacker)
            return item
        }
        
        let newItem: Person3 = .init(
            api: api,
            person2: person2Cache.getModel(api: api, from: apiType.person2ApiBacker),
            instance: instance1Cache.getOptionalModel(api: api, from: apiType.site),
            moderatedCommunities: moderatedCommunities
        )
        itemCache.put(newItem)
        return newItem
    }
}

// Person4 can be created from any Person4ApiBacker, so can't use ApiTypeBackedCache
class Person4Cache: ApiTypeBackedCache<Person4, ApiMyUserInfo> {
    let person3Cache: Person3Cache
    
    init(person3Cache: Person3Cache) {
        self.person3Cache = person3Cache
    }
    
    override func performModelTranslation(api: ApiClient, from apiType: ApiMyUserInfo) -> Person4 {
        .init(api: api, person3: person3Cache.getModel(api: api, from: apiType))
    }
    
    override func updateModel(_ item: Person4, with apiType: ApiMyUserInfo, semaphore: UInt? = nil) {
        item.update(with: apiType)
    }
}

