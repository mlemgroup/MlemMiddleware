//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-29.
//  

import Foundation

extension ModlogChildFetcher {
    class SharedCache {
        typealias TaskResponse = Dictionary<ApiModlogActionType, [ModlogEntry]>
        let api: ApiClient
        let pageSize: Int
        var ongoingTask: Task<TaskResponse, Error>?
        
        init(api: ApiClient, pageSize: Int) {
            self.api = api
            self.pageSize = pageSize
        }
        
        private func fetchItems() async throws -> TaskResponse {
            let response = try await api.getModlog(page: 1, limit: pageSize)
            return .init(grouping: response, by: { $0.type.type })
        }
        
        @MainActor
        func get(type: ApiModlogActionType) async throws -> [ModlogEntry] {
            let task: Task<TaskResponse, Error>
            if let ongoingTask {
                task = ongoingTask
            } else {
                task = Task { try await fetchItems() }
                self.ongoingTask = task
            }
            let response = try await task.result.get()
            return response[type] ?? []
        }
    }
}
