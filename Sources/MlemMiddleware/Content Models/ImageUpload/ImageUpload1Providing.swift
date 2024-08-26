//
//  ImageUpload1Providing.swift
//  
//
//  Created by Sjmarf on 26/08/2024.
//

import Foundation

public protocol ImageUpload1Providing: ContentModel {
    var mediaUpload1: ImageUpload1 { get }
    var url: URL { get }
    var deleted: Bool { get }
}

public extension ImageUpload1Providing {
    /// Delete the image. Doesn't state-fake. Can't be undone.
    func delete() async throws {
        try await api.deleteImage(alias: mediaUpload1.alias, deleteToken: mediaUpload1.deleteToken)
        mediaUpload1.deleted = true
    }
}

public typealias ImageUpload = ImageUpload1Providing
 
