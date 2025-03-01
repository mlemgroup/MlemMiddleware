//
//  File.swift
//  MlemMiddleware
//
//  Created by Sjmarf on 2025-02-07.
//  

import Foundation

public enum ContentLanguage: Hashable {
    case undetermined
    case locale(Locale)
    
    internal init(from language: ApiLanguage) {
        if language.code == "und" {
            self = .undetermined
        } else {
            self = .locale(.init(identifier: language.code))
        }
    }
}
