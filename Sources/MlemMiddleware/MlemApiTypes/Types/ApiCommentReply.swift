//
//  ApiCommentReply.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CommentReply.ts
struct ApiCommentReply: Codable {
    let id: Int
    let recipient_id: Int
    let comment_id: Int
    let read: Bool
    let published: Date
}
