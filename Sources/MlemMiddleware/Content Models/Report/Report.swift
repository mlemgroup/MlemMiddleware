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
    
    init(
        api: ApiClient,
        id: Int,
        creator: Person1,
        resolver: Person1?,
        target: ReportTarget,
        reason: String,
        created: Date,
        updated: Date?
    ) {
        self.api = api
        self.id = id
        self.creator = creator
        self.resolver = resolver
        self.target = target
        self.reason = reason
        self.created = created
        self.updated = updated
    }
}
