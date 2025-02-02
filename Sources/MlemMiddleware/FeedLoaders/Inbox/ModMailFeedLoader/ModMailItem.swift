//
//  ModMailItem.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2025-02-01.
//

public enum ModMailItem: FeedLoadable, ReadableProviding, InboxIdentifiable {
    public typealias FilterType = ModMailItemFilterType
    
    case report(Report)
    case application(RegistrationApplication)
    
    var baseValue: any FeedLoadable {
        switch self {
        case let .report(report): report
        case let .application(application): application
        }
    }
    
    public var read: Bool {
        switch self {
        case .report(let report): report.resolved
        case .application(let application): application.resolution != .unresolved
        }
    }
    
    public var inboxId: Int {
        switch self {
        case let .report(report): report.modMailId
        case let .application(application): application.modMailId
        }
    }
    
    public var api: ApiClient { baseValue.api }
    
    public func sortVal(sortType: FeedLoaderSort.SortType) -> FeedLoaderSort {
        baseValue.sortVal(sortType: sortType)
    }
}
