//
//  ApiClient+RegistrationApplication.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-12.
//  

import Foundation

public extension ApiClient {
    func getRegistrationApplications(
        page: Int = 1,
        limit: Int = 20,
        unreadOnly: Bool = false
    ) async throws -> [RegistrationApplication2] {
        let request = ListRegistrationApplicationsRequest(
            unreadOnly: unreadOnly,
            page: page,
            limit: limit
        )
        let response = try await perform(request)
        return await caches.registrationApplication2.getModels(api: self, from: response.registrationApplications)
    }
    
    @discardableResult
    func approveRegistrationApplication(
        id: Int,
        semaphore: UInt? = nil
    ) async throws -> RegistrationApplication2 {
        let request = ApproveRegistrationApplicationRequest(id: id, approve: true, denyReason: nil)
        let response = try await perform(request)
        return await caches.registrationApplication2.getModel(api: self, from: response.registrationApplication)
    }
    
    @discardableResult
    func denyRegistrationApplication(
        id: Int,
        reason: String?,
        semaphore: UInt? = nil
    ) async throws -> RegistrationApplication2 {
        let request = ApproveRegistrationApplicationRequest(id: id, approve: false, denyReason: reason)
        let response = try await perform(request)
        return await caches.registrationApplication2.getModel(api: self, from: response.registrationApplication)
    }
}
