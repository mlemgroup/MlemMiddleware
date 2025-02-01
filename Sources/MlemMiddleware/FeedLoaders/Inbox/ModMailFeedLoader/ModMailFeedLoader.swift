//
//  ModMailFeedLoader.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2024-11-27.
//

import Foundation

public enum ModMailItem: FeedLoadable, ReadableProviding {
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
    
    public var api: ApiClient { baseValue.api }
    
    public func sortVal(sortType: FeedLoaderSort.SortType) -> FeedLoaderSort {
        baseValue.sortVal(sortType: sortType)
    }
}

public class ModMailFeedLoader: StandardFeedLoader<ModMailItem> {
    
    var modMailFetcher: MultiFetcher<ModMailItem> { fetcher as! MultiFetcher }
    
    public init(
        api: ApiClient,
        pageSize: Int,
        sources: [ChildFeedLoader<ModMailItem>],
        sortType: FeedLoaderSort.SortType,
        showRead: Bool) {
            super.init(
                filter: ModMailItemFilter(showRead: showRead),
                fetcher: MultiFetcher(api: api, pageSize: pageSize, sources: sources, sortType: sortType)
            )
        
        sources.forEach { source in
            source.setParent(parent: self)
        }
    }
    
    public static func setup(
        api: ApiClient,
        pageSize: Int,
        sortType: FeedLoaderSort.SortType,
        showRead: Bool
    ) -> (
        postReportFeedLoader: PostReportChildFeedLoader,
        commentReportFeedLoader: CommentReportChildFeedLoader,
        messageReportFeedLoader: MessageReportChildFeedLoader,
        applicationFeedLoader: ApplicationChildFeedLoader,
        modMailFeedLoader: ModMailFeedLoader
    ) {
        let postReportFeedLoader: PostReportChildFeedLoader = .init(
            api: api,
            pageSize: pageSize,
            sortType: sortType,
            showRead: showRead
        )
        let commentReportFeedLoader: CommentReportChildFeedLoader = .init(
            api: api,
            pageSize: pageSize,
            sortType: sortType,
            showRead: showRead
        )
        let messageReportFeedLoader: MessageReportChildFeedLoader = .init(
            api: api,
            pageSize: pageSize,
            sortType: sortType,
            showRead: showRead
        )
        let applicationFeedLoader: ApplicationChildFeedLoader = .init(
            api: api,
            pageSize: pageSize,
            sortType: sortType,
            showRead: showRead
        )
        
        let modMailFeedLoader: ModMailFeedLoader = .init(
            api: api,
            pageSize: pageSize,
            sources: [postReportFeedLoader, commentReportFeedLoader, messageReportFeedLoader, applicationFeedLoader],
            sortType: sortType,
            showRead: showRead
        )
        
        return (postReportFeedLoader, commentReportFeedLoader, messageReportFeedLoader, applicationFeedLoader, modMailFeedLoader)
    }
    
    public func hideRead() async throws {
        await withThrowingTaskGroup(of: Void.self) { group in
            modMailFetcher.sources.forEach { source in
                group.addTask {
                    guard let childSource = source as? ModMailChildFeedLoader else {
                        assertionFailure("Child is not ModMailChildFeedLoader")
                        return
                    }
                    try await childSource.hideRead()
                }
            }
        }
        
        try await activateFilter(.read)
    }
    
    public func showRead() async throws {
        await withThrowingTaskGroup(of: Void.self) { group in
            modMailFetcher.sources.forEach { source in
                group.addTask {
                    guard let childSource = source as? ModMailChildFeedLoader else {
                        assertionFailure("Child is not ModMailChildFeedLoader")
                        return
                    }
                    try await childSource.showRead()
                }
            }
        }

        try await deactivateFilter(.read)
    }
}
