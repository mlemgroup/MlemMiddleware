//
//  ActiveUserCount.swift
//
//
//  Created by Sjmarf on 29/05/2024.
//

import Foundation

public struct ActiveUserCount {
    let sixMonths: Int
    let month: Int
    let week: Int
    let day: Int
    
    public static let zero: ActiveUserCount = .init(sixMonths: 0, month: 0, week: 0, day: 0)
}
