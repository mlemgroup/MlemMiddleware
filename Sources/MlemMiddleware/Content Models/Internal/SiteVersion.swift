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
    
    public init(_ version: String) {
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
    public var parts: (Int, Int, Int)? {
        switch self {
        case let .release(major, minor, patch):
            return (major, minor, patch)
        default:
            return nil
        }
    }
    // swiftlint: enable large_tuple
    
    public static let v18_0: Self = .init("0.18.0")
    public static let v18_1: Self = .init("0.18.1")
    public static let v18_2: Self = .init("0.18.2")
    public static let v18_3: Self = .init("0.18.3")
    public static let v18_4: Self = .init("0.18.4")
    public static let v18_5: Self = .init("0.18.5")
    public static let v19_0: Self = .init("0.19.0")
    public static let v19_1: Self = .init("0.19.1")
    public static let v19_2: Self = .init("0.19.2")
    public static let v19_3: Self = .init("0.19.3")
    public static let v19_4: Self = .init("0.19.4")
    public static let v19_5: Self = .init("0.19.5")
    public static let v19_6: Self = .init("0.19.6")
    public static let v19_7: Self = .init("0.19.7")
    public static let v19_8: Self = .init("0.19.8")
    public static let v19_9: Self = .init("0.19.9")
}

public extension SiteVersion {
    enum Feature {
        case headerAuthentication, batchMarkRead
        
        var minimumVersion: SiteVersion {
            switch self {
            case .headerAuthentication: .v19_0
            case .batchMarkRead: .v19_0
            }
        }
    }
    
    /// Checks whether this SiteVersion supports the given feature. Always returns false if version unknown.
    func suppports(_ feature: Feature) -> Bool {
        switch self {
        case .other: false
        default: feature.minimumVersion <= self
        }
    }
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
