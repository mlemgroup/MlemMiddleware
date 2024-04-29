//
//  ApiSubscribedType+Extensions.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-02-19.
//

import Foundation

extension ApiSubscribedType {
    public var isSubscribed: Bool { self != .notSubscribed }
}
