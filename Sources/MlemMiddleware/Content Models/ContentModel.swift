//
//  ContentModel.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

public protocol ContentModel {
    static var tierNumber: Int { get }
    var api: ApiClient { get }
}

internal extension ContentModel {
    @MainActor
    func setIfChanged<T: Equatable>(_ keyPath: ReferenceWritableKeyPath<Self, T>, _ value: T) {
        if self[keyPath: keyPath] != value {
            self[keyPath: keyPath] = value
        }
    }
}

public extension ContentModel where Self: ActorIdentifiable {
    var apiIsLocal: Bool {
        api.host == "localhost" || api.host == host
    }
}

public protocol ContentIdentifiable: AnyObject, ContentModel, Hashable, Identifiable {
    static var modelTypeId: ContentType { get }
}

public extension ContentIdentifiable {
    var uid: Int {
        var hasher = Hasher()
        hasher.combine(Self.modelTypeId)
        hasher.combine(id)
        return hasher.finalize()
    }
}

public extension ContentIdentifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(api)
        hasher.combine(id)
        hasher.combine(Self.modelTypeId)
        hasher.combine(Self.tierNumber)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs === rhs
    }
}
