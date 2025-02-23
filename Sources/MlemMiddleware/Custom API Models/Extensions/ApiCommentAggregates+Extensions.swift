//
//  ApiCommentAggregates.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

extension ApiCommentAggregates: ApiContentAggregatesProtocol {
    public var comments: Int { childCount }
    
    internal static var zero: Self {
        .init(id: nil, commentId: 0, score: 0, upvotes: 0, downvotes: 0, published: .distantPast, childCount: 0, hotRank: 0)
    }
}
