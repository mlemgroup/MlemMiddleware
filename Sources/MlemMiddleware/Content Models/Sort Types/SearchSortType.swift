//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-28.
//  

import Foundation

enum SearchSortType {
    case new
    case old
    
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
    
    public static var nonTopCases: [Self] = [.new, .old]
    public static var legacyTopCases: [Self] = LegacySortTimeRange.allCases.map { .top($0) }
    public static var legacyCases: [Self] = nonTopCases + legacyTopCases
    
    public init?(_ legacyApiSortType: ApiSortType) {
        switch legacyApiSortType {
        case .new:
            self = .new
        case .old:
            self = .old
        default:
            if let timeRange = LegacySortTimeRange(legacyApiSortType) {
                self = .top(timeRange)
            } else {
                return nil
            }
        }
    }
    
    /// Returns `nil` if the `PostSortType` is a value that cannot be converted to an `ApiSortType`.
    public var legacyApiSortType: ApiSortType? {
        switch self {
        case .new: .new
        case .old: .old
        case let .top(interval): LegacySortTimeRange(interval)?.legacyApiSortType
        }
    }
    
    public var apiSortType: ApiSearchSortType {
        switch self {
        case .new: .new
        case .old: .old
        case .top: .top
        }
    }
}
