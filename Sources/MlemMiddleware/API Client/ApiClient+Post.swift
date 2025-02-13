//
//  NewApiClient+Post.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

public extension ApiClient {
    // swiftlint:disable:next function_parameter_count
    func getPosts(
        communityId: Int,
        sort: ApiSortType,
        page: Int,
        cursor: String?,
        limit: Int,
        filter: GetContentFilter? = nil,
        showHidden: Bool = false
    ) async throws -> (posts: [Post2], cursor: String?) {
        let request = GetPostsRequest(
            type_: .all,
            sort: sort,
            page: cursor == nil ? page : nil,
            limit: limit,
            communityId: communityId,
            communityName: nil,
            savedOnly: filter == .saved,
            likedOnly: filter == .upvoted,
            dislikedOnly: filter == .downvoted,
            pageCursor: cursor,
            showHidden: showHidden,
            showRead: nil,
            showNsfw: nil
        )
        let response = try await perform(request)
        let posts = await caches.post2.getModels(api: self, from: response.posts)
        return (posts: posts, cursor: response.nextPage)
    }

    // swiftlint:disable:next function_parameter_count
    func getPosts(
        feed: ApiListingType,
        sort: ApiSortType,
        page: Int,
        cursor: String?,
        limit: Int,
        filter: GetContentFilter? = nil,
        showHidden: Bool = false
    ) async throws -> (posts: [Post2], cursor: String?) {
        let request = GetPostsRequest(
            type_: feed,
            sort: sort,
            page: cursor == nil ? page : nil,
            limit: limit,
            communityId: nil,
            communityName: nil,
            savedOnly: filter == .saved,
            likedOnly: filter == .upvoted,
            dislikedOnly: filter == .downvoted,
            pageCursor: cursor,
            showHidden: showHidden,
            showRead: nil,
            showNsfw: nil
        )
        let response = try await perform(request)
        let posts = await caches.post2.getModels(api: self, from: response.posts)
        return (posts: posts, cursor: response.nextPage)
    }
    
    func getPosts(
        personId: Int,
        communityId: Int? = nil,
        sort: ApiSortType = .new,
        page: Int,
        limit: Int,
        savedOnly: Bool = false
    ) async throws -> (person: Person3, posts: [Post2]) {
        let request = GetPersonDetailsRequest(
            personId: personId,
            username: nil,
            sort: sort,
            page: page,
            limit: limit,
            communityId: communityId,
            savedOnly: savedOnly
        )
        let response = try await perform(request)
        return await (
            person: caches.person3.getModel(api: self, from: response),
            posts: caches.post2.getModels(api: self, from: response.posts)
        )
    }
        
    func getPost(id: Int) async throws -> Post3 {
        let request = GetPostRequest(id: id, commentId: nil)
        let response = try await perform(request)
        return await caches.post3.getModel(api: self, from: response)
    }
    
    func getPost(url: URL) async throws -> Post2 {
        let request = ResolveObjectRequest(q: url.absoluteString)
        do {
            if let response = try await perform(request).post {
                return await caches.post2.getModel(api: self, from: response)
            }
        } catch let ApiClientError.response(response, _) where response.couldntFindObject {
            throw ApiClientError.noEntityFound
        }
        throw ApiClientError.noEntityFound
    }
    
    func searchPosts(
        query: String,
        page: Int = 1,
        limit: Int = 20,
        communityId: Int? = nil,
        creatorId: Int? = nil,
        filter: ApiListingType = .all,
        sort: ApiSortType = .topAll
    ) async throws -> [Post2] {
        let request = SearchRequest(
            q: query,
            communityId: communityId,
            communityName: nil,
            creatorId: creatorId,
            type_: .posts,
            sort: sort,
            listingType: filter,
            page: page,
            limit: limit,
            postTitleOnly: false
        )
        let response = try await perform(request)
        return await caches.post2.getModels(api: self, from: response.posts)
    }
    
    /// Mark the given post as read. Works on all versions.
    /// On v0.19.0 and above, if `includeQueuedPosts` is set to `true`, any queued posts will be marked read as well.
    func markPostAsRead(
        id: Int,
        read: Bool = true,
        includeQueuedPosts: Bool = true,
        semaphore: UInt? = nil
    ) async throws {
        // We *must* use `postId` in 0.18 versions, and we *must* use `postIds` from 0.19.4 onwards.
        // On versions 0.19.0 to 0.19.3, either parameter is allowed.
        let request: MarkPostAsReadRequest
        if try await supports(.batchMarkRead) {
            try await self.markPostsAsRead(
                ids: [id],
                read: read,
                includeQueuedPosts: includeQueuedPosts,
                semaphore: semaphore
            )
        } else {
            request = MarkPostAsReadRequest(postId: id, read: read, postIds: nil)
            let response = try await perform(request)
            if !response.success {
                throw ApiClientError.unsuccessful
            }
            await markReadQueue.remove(id)
            Task { @MainActor in
                if let post = caches.post2.retrieveModel(cacheId: id) {
                    post.readManager.updateWithReceivedValue(read, semaphore: semaphore)
                    post.updateReadQueued(false)
                }
            }
        }
    }
    
    /// Mark the given posts as read. Only works on v0.19.0 and above; on lower versions, use `markPostAsRead` instead.
    /// Calling this will also mark any queued posts as read unless `includeQueuedPosts` is set to `false`.
    func markPostsAsRead(
        ids: Set<Int>,
        read: Bool = true,
        includeQueuedPosts: Bool = true,
        semaphore: UInt? = nil
    ) async throws {
        let version = try await version
        guard version >= .v19_0 else { throw ApiClientError.unsupportedLemmyVersion }
        
        let idsToSend: Set<Int>
        let markReadQueueCopy: Set<Int>
        if read, includeQueuedPosts {
            markReadQueueCopy = await markReadQueue.popAll()
            idsToSend = ids.union(markReadQueueCopy)
        } else {
            markReadQueueCopy = []
            idsToSend = ids
        }
        
        guard !idsToSend.isEmpty else { return }
        
        do {
            let request = MarkPostAsReadRequest(postId: nil, read: read, postIds: Array(idsToSend))
            let response = try await perform(request)
            if !response.success {
                throw ApiClientError.unsuccessful
            }
            if read {
                await markReadQueue.subtract(ids)
            }
        } catch {
            await self.markReadQueue.union(markReadQueueCopy)
            throw error
        }
        Task { @MainActor in
            for post in idsToSend.compactMap({ caches.post2.retrieveModel(cacheId: $0) }) {
                post.readManager.updateWithReceivedValue(read, semaphore: semaphore)
                post.updateReadQueued(false)
            }
        }
    }
    
    func flushPostReadQueue() async throws {
        if await !markReadQueue.ids.isEmpty {
            try await markPostsAsRead(ids: [], read: true)
        }
    }
    
    @discardableResult
    func voteOnPost(id: Int, score: ScoringOperation, semaphore: UInt? = nil) async throws -> Post2 {
        let request = LikePostRequest(postId: id, score: score.rawValue)
        let response = try await perform(request)
        return await caches.post2.getModel(api: self, from: response.postView, semaphore: semaphore)
    }
    
    @discardableResult
    func savePost(id: Int, save: Bool, semaphore: UInt? = nil) async throws -> Post2 {
        let request = SavePostRequest(postId: id, save: save)
        let response = try await perform(request)
        return await caches.post2.getModel(api: self, from: response.postView, semaphore: semaphore)
    }
    
    @discardableResult
    func deletePost(id: Int, delete: Bool, semaphore: UInt? = nil) async throws -> Post2 {
        let request = DeletePostRequest(postId: id, deleted: delete)
        let response = try await perform(request)
        return await caches.post2.getModel(api: self, from: response.postView, semaphore: semaphore)
    }
    
    /// Added in 0.19.4
    func hidePosts(
        ids: any Collection<Int>,
        hide: Bool,
        semaphore: UInt? = nil
    ) async throws {
        let request = HidePostRequest(postIds: Array(ids), hide: hide)
        let response = try await perform(request)
        if !response.success {
            throw ApiClientError.unsuccessful
        }
        for post in ids.compactMap({ caches.post2.retrieveModel(cacheId: $0) }) {
            post.hiddenManager.updateWithReceivedValue(hide, semaphore: semaphore)
        }
    }
    
    func hidePost(id: Int, hide: Bool, semaphore: UInt? = nil) async throws {
        try await self.hidePosts(ids: [id], hide: hide, semaphore: semaphore)
    }
    
    func createPost(
        communityId: Int,
        title: String,
        content: String? = nil,
        linkUrl: URL? = nil,
        altText: String? = nil,
        thumbnail: URL? = nil,
        nsfw: Bool,
        languageId: Int? = nil
    ) async throws -> Post2 {
        let request = CreatePostRequest(
            name: title,
            communityId: communityId,
            url: linkUrl?.absoluteString,
            body: content,
            honeypot: nil,
            nsfw: nsfw,
            languageId: languageId,
            altText: altText,
            customThumbnail: thumbnail?.absoluteString
        )
        let response = try await perform(request)
        return await caches.post2.getModel(api: self, from: response.postView)
    }
    
    @discardableResult
    func editPost(
        id: Int,
        title: String,
        content: String? = nil,
        linkUrl: URL? = nil,
        altText: String? = nil,
        thumbnail: URL? = nil,
        nsfw: Bool,
        languageId: Int? = nil
    ) async throws -> Post2 {
        let request = EditPostRequest(
            postId: id,
            name: title,
            url: linkUrl?.absoluteString,
            body: content,
            nsfw: nsfw,
            languageId: languageId,
            altText: altText,
            customThumbnail: thumbnail?.absoluteString
        )
        let response = try await perform(request)
        return await caches.post2.getModel(api: self, from: response.postView)
    }

    func replyToPost(id: Int, content: String, languageId: Int? = nil) async throws -> Comment2 {
        let request = CreateCommentRequest(
            content: content,
            postId: id,
            parentId: nil,
            languageId: languageId,
            formId: nil
        )
        let response = try await perform(request)
        let comment = await caches.comment2.getModel(api: self, from: response.commentView)
        comment.getCachedInboxReply()?.setKnownReadState(newValue: true)
        return comment
    }
    
    @discardableResult
    func reportPost(id: Int, reason: String) async throws -> Report {
        let request = CreatePostReportRequest(postId: id, reason: reason)
        async let response = try await perform(request)
        guard let myPersonId = try await myPersonId else { throw ApiClientError.notLoggedIn }
        return await caches.report.getModel(
            api: self,
            from: try response.postReportView,
            myPersonId: myPersonId
        )
    }
    
    func purgePost(id: Int, reason: String?) async throws {
        let request = PurgePostRequest(postId: id, reason: reason)
        let response = try await perform(request)
        guard response.success else { throw ApiClientError.unsuccessful }
        caches.post1.retrieveModel(cacheId: id)?.purged = true
    }
    
    @discardableResult
    func removePost(
        id: Int,
        remove: Bool,
        reason: String?,
        semaphore: UInt? = nil
    ) async throws -> Post2 {
        let request = RemovePostRequest(postId: id, removed: remove, reason: reason)
        let response = try await perform(request)
        return await caches.post2.getModel(api: self, from: response.postView, semaphore: semaphore)
    }
    
    @discardableResult
    func pinPost(id: Int, pin: Bool, to target: ApiPostFeatureType, semaphore: UInt? = nil) async throws -> Post2 {
        let request = FeaturePostRequest(postId: id, featured: pin, featureType: target)
        let response = try await perform(request)
        return await caches.post2 .getModel(api: self, from: response.postView, semaphore: semaphore)
    }
    
    @discardableResult
    func lockPost(id: Int, lock: Bool, semaphore: UInt? = nil) async throws -> Post2 {
        let request = LockPostRequest(postId: id, locked: lock)
        let response = try await perform(request)
        return await caches.post2.getModel(api: self, from: response.postView, semaphore: semaphore)
    }
    
    @discardableResult
    func getPostVotes(
        id: Int,
        communityId: Int,
        page: Int = 1,
        limit: Int = 20
    ) async throws -> [PersonVote] {
        let request = ListPostLikesRequest(postId: id, page: page, limit: limit)
        let response = try await perform(request)
        return await caches.personVote.getModels(
            api: self,
            from: response.postLikes,
            target: .post(id: id),
            communityId: communityId
        )
    }
}
