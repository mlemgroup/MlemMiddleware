//
//  RegistrationApplication2.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-12.
//  

import Foundation

@Observable
public final class RegistrationApplication2: RegistrationApplication2Providing {
    public static let tierNumber: Int = 2
    public let api: ApiClient
    public var registrationApplication2: RegistrationApplication2 { self }
    
    public let registrationApplication1: RegistrationApplication1
    
    public let creator: Person1
    public internal(set) var resolver: Person1?
    public internal(set) var email: String?
    public internal(set) var emailVerified: Bool
    public internal(set) var showNsfw: Bool
    
    init(
        api: ApiClient,
        registrationApplication1: RegistrationApplication1,
        creator: Person1,
        resolver: Person1?,
        email: String?,
        emailVerified: Bool,
        showNsfw: Bool
    ) {
        self.api = api
        self.registrationApplication1 = registrationApplication1
        self.creator = creator
        self.resolver = resolver
        self.email = email
        self.emailVerified = emailVerified
        self.showNsfw = showNsfw
    }
}
