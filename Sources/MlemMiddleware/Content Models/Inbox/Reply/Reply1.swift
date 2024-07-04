//
//  Reply1.swift
//  
//
//  Created by Sjmarf on 04/07/2024.
//

import Foundation
import Observation

@Observable
public final class Reply1: Reply1Providing {
    public static let tierNumber: Int = 1
    public var api: ApiClient
    public var reply1: Reply1 { self }
    
    public let id: Int
    public let recipientId: Int
    public let commentId: Int
    public let created: Date
    
    public var read: Bool
    
    init(
        api: ApiClient,
        id: Int,
        recipientId: Int,
        commentId: Int,
        created: Date,
        read: Bool
    ) {
        self.api = api
        self.id = id
        self.recipientId = recipientId
        self.commentId = commentId
        self.created = created
        self.read = read
    }
}
