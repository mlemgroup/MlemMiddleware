//
//  Post1Providing.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

public protocol Post1Providing: 
        PostStubProviding,
        ContentIdentifiable,
        Interactable1Providing,
        SelectableContentProviding,
        FeedLoadable where FilterType == PostFilterType {
    var post1: Post1 { get }
    
    var id: Int { get }
    var title: String { get }
    var content: String? { get }
    var linkUrl: URL? { get }
    var deleted: Bool { get }
    var embed: PostEmbed? { get }
    var pinnedCommunity: Bool { get }
    var pinnedInstance: Bool { get }
    var locked: Bool { get }
    var nsfw: Bool { get }
    var created: Date { get }
    var removed: Bool { get }
    var thumbnailUrl: URL? { get }
    var updated: Date? { get }
}

public typealias Post = Post1Providing

public extension Post1Providing {
    static var modelTypeId: ContentType { .post }
    
    var actorId: URL { post1.actorId }
    
    var id: Int { post1.id }
    var title: String { post1.title }
    var content: String? { post1.content }
    var linkUrl: URL? { post1.linkUrl }
    var deleted: Bool { post1.deleted }
    var embed: PostEmbed? { post1.embed }
    var pinnedCommunity: Bool { post1.pinnedCommunity }
    var pinnedInstance: Bool { post1.pinnedInstance }
    var locked: Bool { post1.locked }
    var nsfw: Bool { post1.nsfw }
    var created: Date { post1.created }
    var removed: Bool { post1.removed }
    var thumbnailUrl: URL? { post1.thumbnailUrl }
    var updated: Date? { post1.updated }
    
    var id_: Int? { post1.id }
    var title_: String? { post1.title }
    var content_: String? { post1.content }
    var linkUrl_: URL? { post1.linkUrl }
    var deleted_: Bool? { post1.deleted }
    var embed_: PostEmbed? { post1.embed }
    var pinnedCommunity_: Bool? { post1.pinnedCommunity }
    var pinnedInstance_: Bool? { post1.pinnedInstance }
    var locked_: Bool? { post1.locked }
    var nsfw_: Bool? { post1.nsfw }
    var created_: Date? { post1.created }
    var removed_: Bool? { post1.removed }
    var thumbnailUrl_: URL? { post1.thumbnailUrl }
    var updated_: Date? { post1.updated }
}

// FeedLoadable conformance
public extension Post1Providing {
    func sortVal(sortType: FeedLoaderSortType) -> FeedLoaderSortVal {
        switch sortType {
        case .published:
            return .published(created)
        }
    }
}

// SelectableContentProviding conformance
public extension Post1Providing {
    var selectableContent: String? {
        if let content {
            "\(title)\n\n\(content)"
        } else {
            title
        }
    }
}

public extension Post1Providing {
    var type: PostType {
        // post with URL: either image or link
        if let linkUrl {
            // if image, return image link, otherwise return thumbnail
            return linkUrl.isImage ? .image(linkUrl) : .link(thumbnailUrl)
        }

        // otherwise text, but post.body needs to be present, even if it's an empty string
        if let postBody = content {
            return .text(postBody)
        }

        return .titleOnly
    }
}

public extension Post1Providing {
    func upgrade() async throws -> any Post {
        try await api.getPost(id: id)
    }
    
    func getComments(
        sort: ApiCommentSortType = .hot,
        page: Int,
        maxDepth: Int? = nil,
        limit: Int,
        filter: GetContentFilter? = nil
    ) async throws -> [Comment2] {
        return try await api.getComments(
            postId: id,
            sort: sort,
            page: page,
            maxDepth: maxDepth,
            limit: limit,
            filter: filter
        )
    }
    
    func reply(content: String, languageId: Int? = nil) async throws -> Comment2 {
        try await api.replyToPost(id: id, content: content, languageId: languageId)
    }
    
    func report(reason: String) async throws {
        try await api.reportPost(id: id, reason: reason)
    }
}
