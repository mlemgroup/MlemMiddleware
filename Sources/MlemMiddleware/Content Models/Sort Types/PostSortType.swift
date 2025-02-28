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
    /// Before 1.0.0, there is a discrete list of supported time intervals,
    /// represented by the ``LegacySortTimeRange`` type.
    case top(TimeInterval?)
    
    static func top(_ range: LegacySortTimeRange) -> Self { .top(range.timeInterval) }
    
    public var isTop: Bool {
        switch self {
        case .top: true
        default: false
        }
    }
    
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
    
    public static var legacyTopCases: [Self] = LegacySortTimeRange.allCases.map { .top($0) }
    
    public static var legacyCases: [Self] = nonTopCases + legacyTopCases
    
    public init(_ legacyApiSortType: ApiSortType) {
        self = switch legacyApiSortType {
        case .active: .active
        case .hot: .hot
        case .new: .new
        case .old: .old
        case .mostComments: .mostComments
        case .newComments: .newComments
        case .controversial: .controversial
        case .scaled: .scaled
        default: .top(LegacySortTimeRange(legacyApiSortType)?.timeInterval)
        }
    }
    
    /// Returns `nil` if the `PostSortType` is a value that cannot be converted to an `ApiSortType`.
    public var legacyApiSortType: ApiSortType? {
        switch self {
        case .active: .active
        case .hot: .hot
        case .new: .new
        case .old: .old
        case .mostComments: .mostComments
        case .newComments: .newComments
        case .controversial: .controversial
        case .scaled: .scaled
        case let .top(interval): LegacySortTimeRange(interval)?.legacyApiSortType
        }
    }
    
    public var apiSortType: ApiPostSortType {
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
    
    public var timeRange: TimeInterval? {
        switch self {
        case let .top(timeInterval): timeInterval
        default: nil
        }
    }
    
    public var minimumVersion: SiteVersion {
        switch self {
        case .controversial, .scaled: .v0_19_0
        case let .top(interval): LegacySortTimeRange(interval)?.minimumVersion ?? .v1_0_0
        default: .zero
        }
    }
}
