//
//  ApiClient+Report.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-16.
//

import Foundation

public extension ApiClient {
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
        let response = try await perform(request)
        return await caches.report.getModels(api: self, from: response.postReports)
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
        let response = try await perform(request)
        return await caches.report.getModels(api: self, from: response.commentReports)
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
        let response = try await perform(request)
        return await caches.report.getModels(api: self, from: response.privateMessageReports)
    }
    
    @discardableResult
    func resolveReport(
        id: Int,
        type: ReportType,
        resolved: Bool,
        semaphore: UInt? = nil
    ) async throws -> Report {
        switch type {
        case .post:
            let request = ResolvePostReportRequest(reportId: id, resolved: resolved)
            let response = try await perform(request)
            return await caches.report.getModel(api: self, from: response.postReportView, semaphore: semaphore)
        case .comment:
            let request = ResolveCommentReportRequest(reportId: id, resolved: resolved)
            let response = try await perform(request)
            return await caches.report.getModel(api: self, from: response.commentReportView, semaphore: semaphore)
        case .message:
            let request = ResolvePrivateMessageReportRequest(reportId: id, resolved: resolved)
            let response = try await perform(request)
            return await caches.report.getModel(api: self, from: response.privateMessageReportView, semaphore: semaphore)
        }
    }
}
