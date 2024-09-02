//
//  ApiPictrsFile.swift
//  
//
//  Created by Sjmarf on 26/08/2024.
//

import Foundation

public struct ApiPictrsFile: Codable, Equatable, ImageUpload1Backer {
    public let file: String
    public let deleteToken: String
    
    public var alias: String { file }
    
    public var cacheId: Int { alias.hashValue }
}
