//
//  RegistrationApplication1.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-01-12.
//  

import Foundation

@Observable
public final class RegistrationApplication1: RegistrationApplication1Providing {
    public static let tierNumber: Int = 1
    public let api: ApiClient
    public var registrationApplication1: RegistrationApplication1 { self }
    
    public let id: Int
    public internal(set) var questionResponse: String
    public internal(set) var resolverId: Int?
    public internal(set) var denialReason: String?
    public let created: Date
    
    internal var resolvedManager: StateManager<Bool>
    public var resolved: Bool { resolvedManager.wrappedValue }
    
    init(
        api: ApiClient,
        id: Int,
        questionResponse: String,
        resolverId: Int?,
        denialReason: String,
        created: Date
    ) {
        self.api = api
        self.id = id
        self.questionResponse = questionResponse
        self.resolverId = resolverId
        self.denialReason = denialReason
        self.created = created
        self.resolvedManager = .init(wrappedValue: resolverId != nil)
    }
}
