//
//  InstanceStubProviding.swift
//  
//
//  Created by Sjmarf on 28/05/2024.
//

import Foundation

public protocol InstanceStubProviding: ContentStub {
    // From Instance1Providing. These are defined as nil in the extension below
    var id_: Int? { get }
    var instanceId_: Int? { get }
    var displayName_: String? { get }
    var description_: String? { get }
    var shortDescription_: String? { get }
    var avatar_: URL? { get }
    var banner_: URL? { get }
    var created_: Date? { get }
    var updated_: Date? { get }
    var publicKey_: String? { get }
    var lastRefresh_: Date? { get }
    var contentWarning_: String? { get }
    
    // We cannot calculate this value by comparing actorID to apiCliet.baseUrl
    // because it wouldn't work correctly for locally running instances
    var local_: Bool? { get }
}

public extension InstanceStubProviding {
    var id_: Int? { nil }
    var instanceId_: Int? { nil }
    var displayName_: String? { nil }
    var description_: String? { nil }
    var shortDescription_: String? { nil }
    var avatar_: URL? { nil }
    var banner_: URL? { nil }
    var created_: Date? { nil }
    var updated_: Date? { nil }
    var publicKey_: String? { nil }
    var lastRefresh_: Date? { nil }
    var local_: Bool? { nil }
    var contentWarning_: String? { nil }
}

public enum InstanceUpgradeError: Error {
    case noPostReturned
    case noSiteReturned
}
