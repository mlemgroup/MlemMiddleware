//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-25.
//  

import Foundation

public enum PostSortType: Hashable, Sendable {
    case active
    case hot
    case new
    case old
    case mostComments
    case newComments
    /// Added in 0.19.0
    case controversial
    /// Added in 0.19.0
    case scaled
    
    /// `nil` indicates an infinite time scale ("Top of All Time").
    ///
    /// From 1.0.0 onwards, any time interval is supported.
    /// Before 1.0.0, there is a discrete list of supported time intervals.
    ///
    /// Supported time intervals before 1.0.0:
    /// - 1h
    /// - 6h
    /// - 12h
    /// - 1d
    /// - 1w
    /// - 1mo
    /// - 3mo (added in  0.18.1)
    /// - 6mo (added in  0.18.1)
    /// - 9mo (added in  0.18.1)
    /// - 1y
    /// - All Time
    case top(TimeInterval?)
    
    public static var nonTopCases: [Self] = [
        .hot,
        .scaled,
        .active,
        .new,
        .old,
        .controversial,
        .newComments,
        .mostComments
    ]
    
    public static var allLegacyTopCases: [Self] = LegacyTimeRange.allCases.map { .top($0) }
    
    var legacyApiSortType: ApiSortType? {
        switch self {
        case .active: .active
        case .hot: .hot
        case .new: .new
        case .old: .old
        case .mostComments: .mostComments
        case .newComments: .newComments
        case .controversial: .controversial
        case .scaled: .scaled
        case let .top(interval): LegacyTimeRange(interval)?.legacyApiSortType
        }
    }
    
    var apiSortType: ApiPostSortType {
        switch self {
        case .active: .active
        case .hot: .hot
        case .new: .new
        case .old: .old
        case .mostComments: .mostComments
        case .newComments: .newComments
        case .controversial: .controversial
        case .scaled: .scaled
        case .top: .top
        }
    }
    
    var timeRange: TimeInterval? {
        switch self {
        case let .top(timeInterval): timeInterval
        default: nil
        }
    }
    
    var minimumVersion: SiteVersion {
        switch self {
        case .controversial, .scaled: .v0_19_0
        case let .top(interval): LegacyTimeRange(interval)?.minimumVersion ?? .v1_0_0
        default: .zero
        }
    }
}
