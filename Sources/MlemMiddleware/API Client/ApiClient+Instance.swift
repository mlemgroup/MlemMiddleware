//
//  NewApiClient+Site.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public extension ApiClient {
    func getMyInstance() async throws -> Instance3 {
        let request = GetSiteRequest()
        let response = try await perform(request)
        let model = await caches.instance3.getModel(api: self, from: response)
        model.local = true
        myInstance = model
        return model
    }
    
    func getFederatedInstances() async throws -> ApiFederatedInstances {
        let request = GetFederatedInstancesRequest()
        let response = try await perform(request)
        if let federatedInstances = response.federatedInstances {
            return federatedInstances
        }
        throw ApiClientError.noEntityFound
    }
    
    /// Returns `true` if federated, `false` if not federated, or `nil` if the status could not be determined.
    func federatedWith(with url: URL) async throws -> FederationStatus? {
        guard let domain = url.host() else { throw ApiClientError.invalidInput }
        let federatedInstances = try await getFederatedInstances()
        if !federatedInstances.blocked.isEmpty {
            return federatedInstances.blocked.contains(where: { $0.domain == domain }) ? .explicitlyBlocked : .implicitlyAllowed
        } else if !federatedInstances.allowed.isEmpty {
            return federatedInstances.allowed.contains(where: { $0.domain == domain }) ? .explicitlyAllowed : .implicitlyBlocked
        }
        return nil
    }
    
    /// `instanceId` is distinct from `id`. Make sure to pass `instance.instanceId` and not `id`.
    ///  Technically only `instanceId` is needed to perform this request, but `actorId` is also needed to properly update the `BlockList`.
    func blockInstance(actorId: URL, instanceId: Int, block: Bool, semaphore: UInt? = nil) async throws {
        let request = BlockInstanceRequest(instanceId: instanceId, block: block)
        let response = try await perform(request)
        if let instance = caches.instance1.retrieveModel(instanceId: instanceId) {
            instance.blockedManager.updateWithReceivedValue(response.blocked, semaphore: semaphore)
        }
        if response.blocked {
            blocks?.instances[actorId] = instanceId
        } else {
            blocks?.instances.removeValue(forKey: actorId)
        }
    }
}

extension ApiClient {
    /// Adds or removes an admin from this API's instance
    @discardableResult
    func addAdmin(personId: Int, added: Bool) async throws -> [Person2] {
        let request = AddAdminRequest(personId: personId, added: added)
        let response = try await perform(request)
        
        let updatedAdministrators = await caches.person2.getModels(
            api: self,
            from: response.admins
        )
        
        // update person's admin status
        // only need to do this manually if removing admin, otherwise handled by above caching logic
        if !added, let person = caches.person2.retrieveModel(cacheId: personId) {
            person.isAdmin = false
        }
        
        // update instance admins
        if let myInstance {
            myInstance.administrators = updatedAdministrators
        }
        
        return updatedAdministrators
    }
}
