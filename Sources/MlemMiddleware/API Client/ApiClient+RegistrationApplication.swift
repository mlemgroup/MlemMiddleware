//
//  ApiClient+RegistrationApplication.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-12.
//  

import Foundation

public extension ApiClient {
    func getRegistrationApplicationCount() async throws -> ApiGetUnreadRegistrationApplicationCountResponse {
        try await perform(GetUnreadRegistrationApplicationCountRequest())
    }
    
    func getRegistrationApplications(
        page: Int = 1,
        limit: Int = 20,
        unreadOnly: Bool = false
    ) async throws -> [RegistrationApplication] {
        let request = ListRegistrationApplicationsRequest(
            unreadOnly: unreadOnly,
            page: page,
            limit: limit
        )
        let response = try await perform(request)
        return await caches.registrationApplication.getModels(api: self, from: response.registrationApplications)
    }
    
    @discardableResult
    func approveRegistrationApplication(
        id: Int,
        semaphore: UInt? = nil
    ) async throws -> RegistrationApplication {
        let request = ApproveRegistrationApplicationRequest(id: id, approve: true, denyReason: nil)
        let response = try await perform(request)
        return await caches.registrationApplication.getModel(
            api: self,
            from: response.registrationApplication,
            semaphore: semaphore
        )
    }
    
    @discardableResult
    func denyRegistrationApplication(
        id: Int,
        reason: String?,
        semaphore: UInt? = nil
    ) async throws -> RegistrationApplication {
        let request = ApproveRegistrationApplicationRequest(id: id, approve: false, denyReason: reason)
        let response = try await perform(request)
        return await caches.registrationApplication.getModel(
            api: self,
            from: response.registrationApplication,
            semaphore: semaphore
        )
    }
}
