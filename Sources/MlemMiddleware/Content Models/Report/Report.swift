//
//  Report.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-15.
//

import Foundation
import Observation

@Observable
public class Report: CacheIdentifiable, ContentModel {
    public static let tierNumber: Int = 1
    public var api: ApiClient
    
    // Keep this internal - a post report and a comment report can have the same ID, so it's not a true identifier.
    internal var id: Int
    
    public let created: Date
    public internal(set) var updated: Date?
    public let creator: Person1
    public let target: ReportTarget
    public internal(set) var resolver: Person1?
    public internal(set) var reason: String
    
    internal var resolvedManager: StateManager<Bool>
    public var resolved: Bool { resolvedManager.wrappedValue }
    
    init(
        api: ApiClient,
        id: Int,
        creator: Person1,
        resolver: Person1?,
        target: ReportTarget,
        resolved: Bool,
        reason: String,
        created: Date,
        updated: Date?
    ) {
        self.api = api
        self.id = id
        self.creator = creator
        self.resolver = resolver
        self.target = target
        self.resolvedManager = .init(wrappedValue: resolved)
        self.reason = reason
        self.created = created
        self.updated = updated
    }
    
    @discardableResult
    public func updateResolved(_ newValue: Bool) -> Task<StateUpdateResult, Never> {
        resolvedManager.performRequest(expectedResult: newValue) { semaphore in
            switch self.target.type {
            case .post:
                try await self.api.resolvePostReport(id: self.id, resolved: newValue, semaphore: semaphore)
            case .comment:
                try await self.api.resolveCommentReport(id: self.id, resolved: newValue, semaphore: semaphore)
            case .message:
                try await self.api.resolveMessageReport(id: self.id, resolved: newValue, semaphore: semaphore)
            }
            
        }
    }
    
    @discardableResult
    public func toggleResolved() -> Task<StateUpdateResult, Never> {
        updateResolved(!resolved)
    }
}
