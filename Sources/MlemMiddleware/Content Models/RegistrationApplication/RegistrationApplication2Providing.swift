//
//  RegistrationApplication2Providing.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-12.
//  

import Foundation

public protocol RegistrationApplication2Providing: RegistrationApplication1Providing {
    var registrationApplication2: RegistrationApplication2 { get }
    
    var creator: Person1 { get }
    var resolver: Person1? { get }
    var email: String? { get }
    var emailVerified: Bool { get }
    var showNsfw: Bool { get }
}

public extension RegistrationApplication2Providing {
    var registrationApplication1: RegistrationApplication1 { registrationApplication2.registrationApplication1 }
    
    var creator: Person1 { registrationApplication2.creator }
    var resolver: Person1? { registrationApplication2.resolver }
    var email: String? { registrationApplication2.email }
    var emailVerified: Bool { registrationApplication2.emailVerified }
    var showNsfw: Bool { registrationApplication2.showNsfw }
    
    var creator_: Person1? { registrationApplication2.creator }
    var resolver_: Person1? { registrationApplication2.resolver }
    var email_: String? { registrationApplication2.email }
    var emailVerified_: Bool? { registrationApplication2.emailVerified }
    var showNsfw_: Bool? { registrationApplication2.showNsfw }
}
