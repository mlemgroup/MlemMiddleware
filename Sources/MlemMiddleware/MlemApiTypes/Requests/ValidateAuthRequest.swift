//
//  ValidateAuthRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct ValidateAuthRequest: ApiGetRequest {
    typealias Response = ApiSuccessResponse

    let path = "user/validate_auth"
    let queryItems: [URLQueryItem]

    init() {
        self.queryItems = .init()
    }
}
