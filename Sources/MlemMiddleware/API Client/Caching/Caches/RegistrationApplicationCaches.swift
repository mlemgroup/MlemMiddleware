//
//  RegistrationApplicationCaches.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-12.
//  

import Foundation

class RegistrationApplication1Cache: ApiTypeBackedCache<RegistrationApplication1, ApiRegistrationApplication> {
    @MainActor
    override func performModelTranslation(
        api: ApiClient,
        from apiType: ApiRegistrationApplication
    ) -> RegistrationApplication1 {
        .init(
            api: api,
            id: apiType.id,
            questionResponse: apiType.answer,
            resolverId: apiType.adminId,
            denialReason: apiType.denyReason,
            created: apiType.published
        )
    }
    
    @MainActor
    override func updateModel(
        _ item: RegistrationApplication1,
        with apiType: ApiRegistrationApplication,
        semaphore: UInt? = nil
    ) {
        item.update(with: apiType, semaphore: semaphore)
    }
}

class RegistrationApplication2Cache: ApiTypeBackedCache<RegistrationApplication2, ApiRegistrationApplicationView> {
    @MainActor
    override func performModelTranslation(
        api: ApiClient,
        from apiType: ApiRegistrationApplicationView
    ) -> RegistrationApplication2 {
        .init(
            api: api,
            registrationApplication1: api.caches.registrationApplication1.getModel(api: api, from: apiType.registrationApplication),
            creator: api.caches.person1.getModel(api: api, from: apiType.creator),
            resolver: api.caches.person1.getOptionalModel(api: api, from: apiType.admin),
            email: apiType.creatorLocalUser.email,
            emailVerified: apiType.creatorLocalUser.emailVerified,
            showNsfw: apiType.creatorLocalUser.showNsfw
        )
    }
    
    @MainActor
    override func updateModel(
        _ item: RegistrationApplication2,
        with apiType: ApiRegistrationApplicationView,
        semaphore: UInt? = nil
    ) {
        item.update(with: apiType, semaphore: semaphore)
    }
}
