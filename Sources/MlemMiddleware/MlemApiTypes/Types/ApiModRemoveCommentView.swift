//
//  ApiModRemoveCommentView.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// ModRemoveCommentView.ts
struct ApiModRemoveCommentView: Codable {
    let mod_remove_comment: ApiModRemoveComment
    let moderator: ApiPerson?
    let comment: ApiComment
    let commenter: ApiPerson
    let post: ApiPost
    let community: ApiCommunity
}
