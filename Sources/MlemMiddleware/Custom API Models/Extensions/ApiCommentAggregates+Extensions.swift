//
//  ApiCommentAggregates.swift
//
//
//  Created by Sjmarf on 24/06/2024.
//

import Foundation

extension ApiCommentAggregates: ApiContentAggregatesProtocol {
    public var comments: Int { childCount }
}
