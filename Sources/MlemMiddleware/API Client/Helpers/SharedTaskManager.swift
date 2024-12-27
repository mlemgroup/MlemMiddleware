//
//  SharedTaskManager.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2024-12-27.
//  

import Foundation

internal class SharedTaskManager<Value> {
    let fetchTask: () async throws -> Value
    
    private var ongoingTask: Task<Value, Error>?
    internal private(set) var fetchedValue: Value?
    
    init(fetchTask: @escaping () async throws -> Value) {
        self.fetchTask = fetchTask
    }
    
    func getValue() async throws -> Value {
        if let fetchedValue {
            return fetchedValue
        } else {
            if let ongoingTask {
                let result = await ongoingTask.result
                return try result.get()
            } else {
                return try await fetchTask()
            }
        }
    }
}
