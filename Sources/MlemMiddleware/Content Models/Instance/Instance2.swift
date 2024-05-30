//
//  Instance2.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation
import Observation

@Observable
public final class Instance2: Instance2Providing {
    public static let tierNumber: Int = 2
    public var api: ApiClient
    public var instance2: Instance2 { self }
    
    public let instance1: Instance1

    internal init(api: ApiClient, instance1: Instance1) {
        self.api = api
        self.instance1 = instance1
    }
}
