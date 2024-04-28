//
//  ApiCommentSortType.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// CommentSortType.ts
enum ApiCommentSortType: String, Codable {
    case hot = "Hot"
    case top = "Top"
    case new = "New"
    case old = "Old"
    case controversial = "Controversial" // Exists >=0.19.0
}
