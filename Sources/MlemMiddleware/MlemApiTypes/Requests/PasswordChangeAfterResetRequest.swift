//
//  PasswordChangeAfterResetRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct PasswordChangeAfterResetRequest: ApiPostRequest {
    typealias Body = ApiPasswordChangeAfterReset
    typealias Response = ApiSuccessResponse

    let path = "user/password_change"
    let body: Body?

    init(
      token: String,
      password: String,
      passwordVerify: String
    ) {
        self.body = .init(
          token: token,
          password: password,
          password_verify: passwordVerify
      )
    }
}
