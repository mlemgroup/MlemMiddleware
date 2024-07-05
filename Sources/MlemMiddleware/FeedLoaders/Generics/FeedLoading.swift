//
//  File.swift
//  
//
//  Created by Eric Andrews on 2024-07-05.
//

import Foundation

public protocol FeedLoading {
    associatedtype Item: FeedLoadable
    
    var items: [Item] { get }
    var loadingState: LoadingState { get }
    
    func loadMoreItems() async throws
}
