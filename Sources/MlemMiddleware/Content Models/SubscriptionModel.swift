//
//  SubscriptionModel.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 08/08/2024.
//

import Foundation

internal struct SubscriptionModel: Hashable, Equatable {
    // These are the values actually provided by the API.
    private var actualTotal: Int
    private var actualLocal: Int?
    
    private var subscribedType: ApiSubscribedType
    
    var subscribed: Bool { subscribedType != .notSubscribed }
    var pending: Bool { subscribedType == .pending }
    
    // This accounts for the `actualTotal` not taking your own pending subscription into account.
    var total: Int {
        subscribedType == .pending ? (actualTotal + 1) : actualTotal
    }
    
    // This accounts for the `actualLocal` not taking your own pending subscription into account.
    /// Added in 0.19.4.
    func local(communityIsLocal: Bool) -> Int? {
        guard let actualLocal else { return nil }
        return (communityIsLocal && subscribedType == .pending) ? (actualLocal + 1) : actualLocal
    }
    
    init(from aggregates: ApiCommunityAggregates, subscribedType: ApiSubscribedType) {
        self.actualTotal = aggregates.subscribers
        self.actualLocal = aggregates.subscribersLocal
        self.subscribedType = subscribedType
    }
    
    init(total: Int, local: Int? = nil, subscribedType: ApiSubscribedType) {
        self.actualTotal = total
        self.actualLocal = local
        self.subscribedType = subscribedType
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(actualTotal)
        hasher.combine(actualLocal)
        hasher.combine(subscribedType)
    }
    
    static func == (lhs: SubscriptionModel, rhs: SubscriptionModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension SubscriptionModel {
    func withSubscriptionStatus(subscribed shouldSubscribe: Bool, isLocal: Bool) -> SubscriptionModel {
        guard shouldSubscribe != self.subscribed else { return self }
        
        let newSubscribedType: ApiSubscribedType
        if shouldSubscribe {
            // When you subscribe, your instance asks the community host to confirm the subscription.
            // Until a confirmation is received from the host, `.pending` is returned. Therefore we
            // assume `.pending` will be returned for non-local communities when state-faking the status.
            // The subscription count doesn't change either until the subscription status is confirmed
            // by the community host.
            newSubscribedType = isLocal ? .subscribed : .pending
        } else {
            newSubscribedType = .notSubscribed
        }
        
        let diff: Int
        switch newSubscribedType {
        case .notSubscribed:
            // It appears there is also a "pending" state when unsubscribing, but we don't get to know
            // when it's in this state. The consequence of this is that the count may not update when
            // unsubscribing until confirmation is received.
            diff = isLocal ? -1 : 0
        case .pending:
            diff = 0
        case .subscribed:
            diff = 1
        }
        
        let newLocal: Int?
        if let actualLocal {
            newLocal = isLocal ? (actualLocal + diff) : actualLocal
        } else {
            newLocal = nil
        }
        
        return SubscriptionModel(
            total: actualTotal + diff,
            local: newLocal,
            subscribedType: newSubscribedType
        )
    }
}
