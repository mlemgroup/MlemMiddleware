//
//  LoginRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct LoginRequest: ApiPostRequest {
    typealias Body = ApiLogin
    typealias Response = ApiLoginResponse

    let path = "user/login"
    let body: Body?

    init(
      usernameOrEmail: String,
      password: String,
      totp2faToken: String?
    ) {
        self.body = .init(
          username_or_email: usernameOrEmail,
          password: password,
          totp_2fa_token: totp2faToken
      )
    }
}
