//
//  LogoutRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct LogoutRequest: ApiPostRequest {
    typealias Body = Int // dummy type for APIRequestBodyProviding conformance
    typealias Response = ApiSuccessResponse

    let path = "user/logout"
    let body: Body?

    init() {
        self.body = nil
    }
}
