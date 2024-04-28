//
//  ApiSortType.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

// SortType.ts
enum ApiSortType: String, Codable {
    case active = "Active"
    case hot = "Hot"
    case new = "New"
    case old = "Old"
    case topDay = "TopDay"
    case topWeek = "TopWeek"
    case topMonth = "TopMonth"
    case topYear = "TopYear"
    case topAll = "TopAll"
    case mostComments = "MostComments"
    case newComments = "NewComments"
    case topHour = "TopHour"
    case topSixHour = "TopSixHour"
    case topTwelveHour = "TopTwelveHour"
    case topThreeMonths = "TopThreeMonths" // Exists >=0.18.1
    case topSixMonths = "TopSixMonths" // Exists >=0.18.1
    case topNineMonths = "TopNineMonths" // Exists >=0.18.1
    case controversial = "Controversial" // Exists >=0.19.0
    case scaled = "Scaled" // Exists >=0.19.0
}
