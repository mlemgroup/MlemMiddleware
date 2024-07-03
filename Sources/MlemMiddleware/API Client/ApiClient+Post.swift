//
//  NewApiClient+Post.swift
//  Mlem
//
//  Created by Sjmarf on 16/02/2024.
//

import Foundation

extension ApiClient: PostFeedProvider {
    // swiftlint:disable:next function_parameter_count
    public func getPosts(
        communityId: Int,
        sort: ApiSortType,
        page: Int,
        cursor: String?,
        limit: Int,
        savedOnly: Bool = false
    ) async throws -> (posts: [Post2], cursor: String?) {
        let request = GetPostsRequest(
            type_: .all,
            sort: sort,
            page: cursor == nil ? page : nil,
            limit: limit,
            communityId: communityId,
            communityName: nil,
            savedOnly: savedOnly,
            likedOnly: nil,
            dislikedOnly: nil,
            pageCursor: cursor,
            showHidden: false
        )
        let response = try await perform(request)
        let posts = response.posts.map { caches.post2.getModel(api: self, from: $0) }
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
        return (
            person: caches.person3.getModel(api: self, from: response),
            posts: response.posts.map { caches.post2.getModel(api: self, from: $0) }
        )
    }
    
    // swiftlint:disable:next function_parameter_count
    public func getPosts(
        feed: ApiListingType,
        sort: ApiSortType,
        page: Int,
        cursor: String?,
        limit: Int,
        savedOnly: Bool = false
    ) async throws -> (posts: [Post2], cursor: String?) {
        let request = GetPostsRequest(
            type_: feed,
            sort: sort,
            page: cursor == nil ? page : nil,
            limit: limit,
            communityId: nil,
            communityName: nil,
            savedOnly: savedOnly,
            likedOnly: nil,
            dislikedOnly: nil,
            pageCursor: cursor,
            showHidden: false
        )
        let response = try await perform(request)
        let posts = response.posts.map { caches.post2.getModel(api: self, from: $0) }
        return (posts: posts, cursor: response.nextPage)
    }
    
    public func getPost(id: Int) async throws -> Post2 {
        let request = GetPostRequest(id: id, commentId: nil)
        let response = try await perform(request)
        return caches.post2.getModel(api: self, from: response.postView)
    }
    
    public func getPost(actorId: URL) async throws -> Post2 {
        let request = ResolveObjectRequest(q: actorId.absoluteString)
        do {
            if let response = try await perform(request).post {
                return caches.post2.getModel(api: self, from: response)
            }
        } catch let ApiClientError.response(response, _) where response.couldntFindObject {
            throw ApiClientError.noEntityFound
        }
        throw ApiClientError.noEntityFound
    }
    
    /// Mark the given post as read. Works on all versions.
    /// On v0.19.0 and above, calling this will also mark any queued posts as read unless `includeQueuedPosts` is set to `false`.
    public func markPostAsRead(
        id: Int,
        read: Bool = true,
        includeQueuedPosts: Bool = true,
        semaphore: UInt? = nil
    ) async throws {
        // We *must* use `postId` in 0.18 versions, and we *must* use `postIds` from 0.19.4 onwards.
        // On versions 0.19.0 to 0.19.3, either parameter is allowed.
        let version = try await version
        let request: MarkPostAsReadRequest
        if version >= .v19_0 {
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
            if let post = caches.post2.retrieveModel(cacheId: id) {
                post.readManager.updateWithReceivedValue(read, semaphore: semaphore)
                post.readQueued = false
            }
        }
    }
    
    /// Mark the given posts as read. Only works on v0.19.0 and above; on lower versions, use `markPostAsRead` instead.
    /// Calling this will also mark any queued posts as read unless `includeQueuedPosts` is set to `false`.
    public func markPostsAsRead(
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
        for post in idsToSend.compactMap({ caches.post2.retrieveModel(cacheId: $0) }) {
            post.readManager.updateWithReceivedValue(read, semaphore: semaphore)
            post.readQueued = false
        }
    }
    
    public func flushPostReadQueue() async throws {
        if await !markReadQueue.ids.isEmpty {
            try await markPostsAsRead(ids: [], read: true)
        }
    }
    
    @discardableResult
    public func voteOnPost(id: Int, score: ScoringOperation, semaphore: UInt? = nil) async throws -> Post2 {
        let request = LikePostRequest(postId: id, score: score.rawValue)
        let response = try await perform(request)
        return caches.post2.getModel(api: self, from: response.postView, semaphore: semaphore)
    }
    
    @discardableResult
    public func savePost(id: Int, save: Bool, semaphore: UInt? = nil) async throws -> Post2 {
        let request = SavePostRequest(postId: id, save: save)
        let response = try await perform(request)
        return caches.post2.getModel(api: self, from: response.postView, semaphore: semaphore)
    }
}
