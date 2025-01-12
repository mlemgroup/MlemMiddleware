//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-12.
//  

import Foundation

extension RegistrationApplication1: CacheIdentifiable {
    public var cacheId: Int { id }
    
    @MainActor
    func update(with application: ApiRegistrationApplication, semaphore: UInt? = nil) {
        setIfChanged(\.questionResponse, application.answer)
        setIfChanged(\.resolverId, application.adminId)
        setIfChanged(\.denialReason, application.denyReason)
        resolvedManager.updateWithReceivedValue(application.adminId == nil, semaphore: semaphore)
    }
}

extension RegistrationApplication2: CacheIdentifiable {
    public var cacheId: Int { id }
    
    @MainActor
    func update(with applicationView: ApiRegistrationApplicationView, semaphore: UInt? = nil) {
        setIfChanged(\.resolver, api.caches.person1.getOptionalModel(api: api, from: applicationView.admin))
        setIfChanged(\.email, applicationView.creatorLocalUser.email)
        setIfChanged(\.emailVerified, applicationView.creatorLocalUser.emailVerified)
        setIfChanged(\.showNsfw, applicationView.creatorLocalUser.showNsfw)
        creator.update(with: applicationView.creator)
        registrationApplication1.update(with: applicationView.registrationApplication, semaphore: semaphore)
    }
}
