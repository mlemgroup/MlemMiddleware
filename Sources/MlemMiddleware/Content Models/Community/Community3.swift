//
//  CommunityTier3.swift
//  Mlem
//
//  Created by Sjmarf on 03/02/2024.
//

import Observation
import SwiftUI

@Observable
public final class Community3: Community3Providing {
    public var community3: Community3 { self }
    public let api: ApiClient
    
    public let community2: Community2
    
    public var instance: Instance1! // TODO: no force unwrapping
    public var moderators: [Person1] = .init()
    public var discussionLanguages: [Int] = .init()
  
    public init(
        api: ApiClient,
        community2: Community2,
        instance: Instance1?,
        moderators: [Person1] = .init(),
        discussionLanguages: [Int] = .init()
    ) {
        self.api = api
        self.community2 = community2
        self.instance = instance
        self.moderators = moderators
        self.discussionLanguages = discussionLanguages
    }
    
    public func upgrade() async throws -> Community3 { self }
}
