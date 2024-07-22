//
//  File.swift
//  
//
//  Created by Sjmarf on 28/05/2024.
//

import Foundation

public struct InstanceStub: InstanceStubProviding, Hashable {
    static public var tierNumber: Int = 0
    public var api: ApiClient
    public let actorId: URL
    
    public var local: Bool { actorId == api.baseUrl }
    
    public init(api: ApiClient, actorId: URL) {
        self.api = api
        self.actorId = actorId
    }
    
    public func asLocal() -> Self {
        .init(api: .getApiClient(for: actorId.removingPathComponents(), with: nil), actorId: actorId)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(actorId)
    }
    
    public static func == (lhs: InstanceStub, rhs: InstanceStub) -> Bool {
        lhs.actorId == rhs.actorId
    }
}

// These are defined here rather than in `InstanceStubProviding`
// because `upgrade()` only goes up to `Instance1`, not `Instance3`.
// The names of `upgrade` methods on higher-tier models would be
// misleading because they would instead downgrade the model.
public extension InstanceStub {
    /// Upgrades to an ``Instance1`` -  the highest tier that can be upgraded to without using the local ``ApiClient`` instead.
    /// Use ``upgradeLocal()`` if you need an ``Instance3``. This method does not work for locally running instances.
    ///
    /// Due to API limitations (see [here](https://github.com/mlemgroup/mlem/pull/1029#issuecomment-2067746011)),
    /// it takes 4 API calls to perform this upgrade.
    func upgrade() async throws -> Instance1 {
        let externalApi: ApiClient = .getApiClient(for: actorId, with: nil)
        
        let response = try await externalApi.getPosts(
            feed: .local,
            sort: .new,
            page: 1,
            cursor: nil,
            limit: 1
        )
        
        guard let post = response.posts.first else {
            throw InstanceUpgradeError.noPostReturned
        }
        
        let comm: Community3 = try await api.getCommunity(actorId: post.community.actorId)
        
        guard let instance = comm.instance else {
            throw InstanceUpgradeError.noSiteReturned
        }
        
        return instance
    }
}
