//
//  ApiResolveObjectResponse.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ResolveObjectResponse.ts
struct ApiResolveObjectResponse: Codable {
    let comment: ApiCommentView?
    let post: ApiPostView?
    let community: ApiCommunityView?
    let person: ApiPersonView?
}