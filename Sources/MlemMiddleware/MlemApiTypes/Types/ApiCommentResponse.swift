//
//  ApiCommentResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CommentResponse.ts
struct ApiCommentResponse: Codable {
    let comment_view: ApiCommentView
    let recipient_ids: [Int]
    let form_id: String? // Exists <=0.18.3
}
