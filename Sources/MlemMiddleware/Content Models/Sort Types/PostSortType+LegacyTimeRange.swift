//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-25.
//  

import Foundation

public extension PostSortType {
    enum LegacyTimeRange: CaseIterable {
        case hour
        case sixHour
        case twelveHour
        case day
        case week
        case month
        /// Added in 0.18.1
        case threeMonth
        /// Added in 0.18.1
        case sixMonth
        /// Added in 0.18.1
        case nineMonth
        case year
        case allTime
    }
    
    static func top(_ range: LegacyTimeRange) -> Self {
        .top(range.timeInterval)
    }
}

public extension PostSortType.LegacyTimeRange {
    init?(_ timeInterval: TimeInterval?) {
        if let match = Self.allCases.first(where: { $0.timeInterval == timeInterval }) {
            self = match
        } else {
            return nil
        }
    }
    
    var timeInterval: TimeInterval? {
        let hour = 3600.0
        let day = hour * 24
        let month = day * 30
        
        return switch self {
        case .hour: hour
        case .sixHour: hour * 6
        case .twelveHour: hour * 12
        case .day: day
        case .week: day * 7
        case .month: month
        case .threeMonth: month * 3
        case .sixMonth: month * 6
        case .nineMonth: month * 9
        case .year: day * 365
        case .allTime: nil
        }
    }
    
    var legacyApiSortType: ApiSortType {
        switch self {
        case .hour: .topHour
        case .sixHour: .topSixHour
        case .twelveHour: .topTwelveHour
        case .day: .topDay
        case .week: .topWeek
        case .month: .topMonth
        case .threeMonth: .topThreeMonths
        case .sixMonth: .topSixMonths
        case .nineMonth: .topNineMonths
        case .year: .topYear
        case .allTime: .topAll
        }
    }
    
    var minimumVersion: SiteVersion {
        switch self {
        case .threeMonth, .sixMonth, .nineMonth: .v0_18_1
        default: .zero
        }
    }
}
