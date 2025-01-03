//
//  FeedLoading.swift
//  
//
//  Created by Eric Andrews on 2024-07-05.
//

import Foundation
import MlemMiddleware

public protocol FeedLoading<Item>: AnyObject {
    associatedtype Item: FeedLoadable
    
    var items: [Item] { get }
    var loadingState: LoadingState { get }
    
    func loadMoreItems() async throws
    func loadIfThreshold(_ item: Item) throws
    func refresh(clearBeforeRefresh: Bool) async throws
    func clear() async
    func changeApi(to newApi: ApiClient, context: FilterContext) async
}
