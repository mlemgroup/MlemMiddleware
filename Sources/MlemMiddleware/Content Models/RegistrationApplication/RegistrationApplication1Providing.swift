//
//  RegistrationApplication1Providing.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-12.
//  

import Foundation

public protocol RegistrationApplication1Providing: ContentModel {
    var registrationApplication1: RegistrationApplication1 { get }
    
    var id: Int { get }
    var questionResponse: String { get }
    var resolverId: Int? { get }
    var denialReason: String? { get }
    var created: Date { get }
    var resolved: Bool { get }
    
    var creator_: Person1? { get }
    var resolver_: Person1? { get }
    var email_: String? { get }
    var emailVerified_: Bool? { get }
    var showNsfw_: Bool? { get }
}

public extension RegistrationApplication1Providing {
    var id: Int { registrationApplication1.id }
    var questionResponse: String { registrationApplication1.questionResponse }
    var resolverId: Int? { registrationApplication1.resolverId }
    var denialReason: String? { registrationApplication1.denialReason }
    var created: Date { registrationApplication1.created }
    var resolved: Bool { registrationApplication1.resolved }
    
    var creator_: Person1? { nil }
    var resolver_: Person1? { nil }
    var email_: String? { nil }
    var emailVerified_: Bool? { nil }
    var showNsfw_: Bool? { nil }
}
