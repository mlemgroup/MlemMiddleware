//
//  CommentSortType.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-03-04.
//  

import SwiftUI

public enum CommentSortType: Hashable, Sendable {
    case new
    case old
    case hot
    
    /// Added in 0.19.0
    case controversial
    
    /// From 1.0.0 onwards, any time interval is supported.
    /// Before 1.0.0, only `.allTime` is supported.
    case top(SortTimeRange)
    
    public var isTop: Bool {
        switch self {
        case .top: true
        default: false
        }
    }
    
    public static var nonTopCases: [Self] = [
        .hot,
        .new,
        .old,
        .controversial
    ]
    
    public static var legacyCases: [Self] = nonTopCases + [.top(.allTime)]
    
    public init(_ apiSortType: ApiCommentSortType) {
        self = switch apiSortType {
        case .hot: .hot
        case .top: .top(.allTime)
        case .new: .new
        case .old: .old
        case .controversial: .controversial
        }
    }
    
    public var apiSortType: ApiCommentSortType {
        switch self {
        case .new: .new
        case .old: .old
        case .hot: .hot
        case .controversial: .controversial
        case let .top(sortTimeRange): .top
        }
    }
    
    public var timeRange: SortTimeRange? {
        switch self {
        case let .top(timeRange): timeRange
        default: nil
        }
    }
    
    // This should only be used internally within ApiClient
    internal var timeRangeSeconds: Int? { timeRange?.timeRangeSeconds }
    
    public var minimumVersion: SiteVersion {
        switch self {
        case .controversial: .v0_19_0
        case let .top(timeRange): timeRange == .allTime ? .zero : .v1_0_0
        default: .zero
        }
    }
}
