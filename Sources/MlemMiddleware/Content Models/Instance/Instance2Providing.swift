//
//  Instance2Providing.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public protocol Instance2Providing: Instance1Providing {
    var instance2: Instance2 { get }
}

public extension Instance2Providing {
    var instance1: Instance1 { instance2.instance1 }
}
