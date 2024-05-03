//
//  ApiSiteVersionNumber.swift
//  Mlem
//
//  Created by Sjmarf on 09/09/2023.
//
import Foundation

public enum SiteVersion: Equatable, Hashable {
    case release(major: Int, minor: Int, patch: Int)
    case other(String)
    case zero
    case infinity
    
    init(_ version: String) {
        let parts = version.split(separator: "-")
        if let firstPart = parts.first {
            let components = firstPart.split(separator: ".").compactMap { Int($0) }
            if components.count == 3 {
                self = .release(major: components[0], minor: components[1], patch: components[2])
            } else {
                self = .other(version)
            }
        } else {
            self = .other(version)
        }
    }
    
    // swiftlint: disable large_tuple
    var parts: (Int, Int, Int)? {
        switch self {
        case let .release(major, minor, patch):
            return (major, minor, patch)
        default:
            return nil
        }
    }
    // swiftlint: enable large_tuple
}

extension SiteVersion: CustomStringConvertible {
    public var description: String {
        switch self {
        case .zero:
            return "zero"
        case .infinity:
            return "infinity"
        case let .release(major, minor, patch):
            return "\(major).\(minor).\(patch)"
        case let .other(string):
            return string
        }
    }
}

extension SiteVersion: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let versionString = try container.decode(String.self)
        self.init(versionString)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(describing: self))
    }
}

extension SiteVersion: Comparable {
    public static func < (lhs: SiteVersion, rhs: SiteVersion) -> Bool {
        switch (lhs, rhs) {
        case (.release, .release):
            return lhs.parts! < rhs.parts!
            
        case (.zero, _), (_, .infinity):
            return true
            
        case (_, .zero), (.infinity, _):
            return false
        default:
            return false
        }
    }
}