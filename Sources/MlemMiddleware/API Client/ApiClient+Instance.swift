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
        var model = caches.instance3.getModel(api: self, from: response)
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
    
    @discardableResult
    /// `instanceId` is distinct from `id`. Make sure to pass `instance.instanceId` and not `id`.
    func blockInstance(instanceId: Int, block: Bool, semaphore: UInt? = nil) async throws {
        let request = BlockInstanceRequest(instanceId: instanceId, block: block)
        let response = try await perform(request)
        // TODO THIS PR fix this
        // caches.instance1.retrieveModel(cacheId:)
    }
}
