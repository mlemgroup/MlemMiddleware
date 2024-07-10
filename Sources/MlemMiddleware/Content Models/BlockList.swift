//
//  BlockList.swift
//
//
//  Created by Sjmarf on 08/07/2024.
//

import Foundation

@Observable
public class BlockList {
    public struct Item: Hashable {
        /// `id` is the `instanceId` when used for instances
        let id: Int
        let actorId: URL
    }
    
    private let api: ApiClient
    public internal(set) var people: Set<Item>
    public internal(set) var communities: Set<Item>
    public internal(set) var instances: Set<Item>
    
    internal init(
        api: ApiClient,
        people: Set<Item>,
        communities: Set<Item>,
        instances: Set<Item>
    ) {
        self.api = api
        self.people = people
        self.communities = communities
        self.instances = instances
    }
    
    convenience internal init(
        api: ApiClient,
        people: [ApiPersonBlockView],
        communities: [ApiCommunityBlockView],
        instances: [ApiInstanceBlockView]
    ) {
        self.init(
            api: api,
            people: Set<Item>(),
            communities: Set<Item>(),
            instances: Set<Item>()
        )
        
        self.update(people: people, communities: communities, instances: instances)
    }
    
    convenience internal init(api: ApiClient, myUserInfo: ApiMyUserInfo) {
        self.init(
            api: api,
            people: myUserInfo.personBlocks,
            communities: myUserInfo.communityBlocks,
            instances: myUserInfo.instanceBlocks ?? []
        )
    }
    
    func update(
        people: [ApiPersonBlockView],
        communities: [ApiCommunityBlockView],
        instances: [ApiInstanceBlockView]
    ) {
        let newPeople: Set<Item> = .init(people.lazy.map { .init(id: $0.target.id, actorId: $0.target.actorId) })
        let newCommunities: Set<Item> = .init(communities.lazy.map { .init(id: $0.community.id, actorId: $0.community.actorId) })
        let newInstances: Set<Item> = .init(instances.lazy.compactMap {
            if let url = URL(string: $0.instance.domain) {
                return .init(id: $0.instance.id, actorId: url)
            }
            return nil
        })
        
        for item in newPeople.subtracting(self.people) {
            if let person = api.caches.person1.retrieveModel(cacheId: item.id) {
                person.blockedManager.updateWithReceivedValue(true, semaphore: nil)
            }
        }
        
        for item in newCommunities.subtracting(self.communities) {
            if let person = api.caches.community1.retrieveModel(cacheId: item.id) {
                person.blockedManager.updateWithReceivedValue(true, semaphore: nil)
            }
        }
        
        for item in newInstances.subtracting(self.instances) {
            if let person = api.caches.instance1.retrieveModel(instanceId: item.id) {
                person.blockedManager.updateWithReceivedValue(true, semaphore: nil)
            }
        }
        
        // ------
        
        for item in self.people.subtracting(newPeople) {
            if let person = api.caches.person1.retrieveModel(cacheId: item.id) {
                person.blockedManager.updateWithReceivedValue(false, semaphore: nil)
            }
        }
        
        for item in self.communities.subtracting(newCommunities) {
            if let person = api.caches.community1.retrieveModel(cacheId: item.id) {
                person.blockedManager.updateWithReceivedValue(false, semaphore: nil)
            }
        }
        
        for item in self.instances.subtracting(newInstances) {
            if let person = api.caches.instance1.retrieveModel(instanceId: item.id) {
                person.blockedManager.updateWithReceivedValue(false, semaphore: nil)
            }
        }
        
        self.people = newPeople
        self.communities = newCommunities
        self.instances = newInstances
    }
    
    func update(myUserInfo: ApiMyUserInfo) {
        self.update(
            people: myUserInfo.personBlocks,
            communities: myUserInfo.communityBlocks,
            instances: myUserInfo.instanceBlocks ?? []
        )
    }
}
