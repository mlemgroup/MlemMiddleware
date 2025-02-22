//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-21.
//  

import Foundation

extension ApiModlogCombinedView {
    var wrappedValue: any ModlogEntryApiBacker {
        switch self {
        case let .adminAllowInstance(value): value
        case let .adminBlockInstance(value): value
        case let .adminPurgeComment(value): value
        case let .adminPurgeCommunity(value): value
        case let .adminPurgePerson(value): value
        case let .adminPurgePost(value): value
        case let .modAdd(value): value
        case let .modAddCommunity(value): value
        case let .modBan(value): value
        case let .modBanFromCommunity(value): value
        case let .modFeaturePost(value): value
        case let .modHideCommunity(value): value
        case let .modLockPost(value): value
        case let .modRemoveComment(value): value
        case let .modRemoveCommunity(value): value
        case let .modRemovePost(value): value
        case let .modTransferCommunity(value): value
        }
    }
}
