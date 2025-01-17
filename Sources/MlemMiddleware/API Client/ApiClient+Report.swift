//
//  ApiClient+Report.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-16.
//

import Foundation

public extension ApiClient {
    func getReportCount(communityId: Int? = nil) async throws -> ApiGetReportCountResponse {
        try await perform(GetReportCountRequest(communityId: communityId))
    }
    
    func getPostReports(
        page: Int = 1,
        limit: Int = 20,
        unresolvedOnly: Bool = false,
        communityId: Int? = nil,
        postId: Int? = nil
    ) async throws -> [Report] {
        let request = ListPostReportsRequest(
            page: page,
            limit: limit,
            unresolvedOnly: unresolvedOnly,
            communityId: communityId,
            postId: postId
        )
        async let response = try await perform(request)
        guard let myPersonId = try await myPersonId else { throw ApiClientError.notLoggedIn }
        return await caches.report.getModels(
            api: self,
            from: try response.postReports,
            myPersonId: myPersonId
        )
    }
    
    func getCommentReports(
        page: Int = 1,
        limit: Int = 20,
        unresolvedOnly: Bool = false,
        communityId: Int? = nil,
        commentId: Int? = nil
    ) async throws -> [Report] {
        let request = ListCommentReportsRequest(
            page: page,
            limit: limit,
            unresolvedOnly: unresolvedOnly,
            communityId: communityId,
            commentId: commentId
        )
        async let response = try await perform(request)
        guard let myPersonId = try await myPersonId else { throw ApiClientError.notLoggedIn }
        return await caches.report.getModels(
            api: self,
            from: try response.commentReports,
            myPersonId: myPersonId
        )
    }
    
    func getMessageReports(
        page: Int = 1,
        limit: Int = 20,
        unresolvedOnly: Bool = false
    ) async throws -> [Report] {
        let request = ListPrivateMessageReportsRequest(
            page: page,
            limit: limit,
            unresolvedOnly: unresolvedOnly
        )
        async let response = try await perform(request)
        guard let myPersonId = try await myPersonId else { throw ApiClientError.notLoggedIn }
        return await caches.report.getModels(
            api: self,
            from: try response.privateMessageReports,
            myPersonId: myPersonId
        )
    }
    
    @discardableResult
    func resolvePostReport(
        id: Int,
        resolved: Bool,
        semaphore: UInt? = nil
    ) async throws -> Report {
        let request = ResolvePostReportRequest(reportId: id, resolved: resolved)
        async let response = try await perform(request)
        guard let myPersonId = try await myPersonId else { throw ApiClientError.notLoggedIn }
        return await caches.report.getModel(
            api: self,
            from: try response.postReportView,
            myPersonId: myPersonId,
            semaphore: semaphore
        )
    }
    
    @discardableResult
    func resolveCommentReport(
        id: Int,
        resolved: Bool,
        semaphore: UInt? = nil
    ) async throws -> Report {
        let request = ResolveCommentReportRequest(reportId: id, resolved: resolved)
        async let response = try await perform(request)
        guard let myPersonId = try await myPersonId else { throw ApiClientError.notLoggedIn }
        return await caches.report.getModel(
            api: self,
            from: try response.commentReportView,
            myPersonId: myPersonId,
            semaphore: semaphore
        )
    }
    
    @discardableResult
    func resolveMessageReport(
        id: Int,
        resolved: Bool,
        semaphore: UInt? = nil
    ) async throws -> Report {
        let request = ResolvePrivateMessageReportRequest(reportId: id, resolved: resolved)
        async let response = try await perform(request)
        guard let myPersonId = try await myPersonId else { throw ApiClientError.notLoggedIn }
        return await caches.report.getModel(
            api: self,
            from: try response.privateMessageReportView,
            myPersonId: myPersonId,
            semaphore: semaphore
        )
    }
}
