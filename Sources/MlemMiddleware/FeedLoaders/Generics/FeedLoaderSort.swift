//
//  FeedLoaderSort.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-10-15.
//
import Foundation

public enum FeedLoaderSortType {
    case published
}

// TODO: consolidate into a single enum, proxy ApiListingType, contain Sort as member here
public enum FeedLoaderSortVal: Comparable {
    case published(Date)
    
    static func typeEquals(lhs: FeedLoaderSortVal, rhs: FeedLoaderSortVal) -> Bool {
        switch lhs {
        case .published:
            switch rhs {
            case .published:
                return true
            }
        }
    }
    
    public static func < (lhs: FeedLoaderSortVal, rhs: FeedLoaderSortVal) -> Bool {
        guard typeEquals(lhs: lhs, rhs: rhs) else {
            assertionFailure("Compare called on trackersortvals with different types")
            return true
        }
        
        switch lhs {
        case let .published(lhsDate):
            switch rhs {
            case let .published(rhsDate):
                return lhsDate < rhsDate
            }
        }
    }
}
