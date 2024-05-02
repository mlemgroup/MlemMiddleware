//
//  Actionable.swift
//  Mlem
//
//  Created by Sjmarf on 30/03/2024.
//

import Foundation

public protocol Actionable {
    func action(ofType type: ActionType) -> (any Action)?
}
