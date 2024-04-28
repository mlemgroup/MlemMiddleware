//
//  ChangePasswordRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct ChangePasswordRequest: ApiPutRequest {
    typealias Body = ApiChangePassword
    typealias Response = ApiLoginResponse

    let path = "user/change_password"
    let body: Body?

    init(
      newPassword: String,
      newPasswordVerify: String,
      oldPassword: String
    ) {
        self.body = .init(
          new_password: newPassword,
          new_password_verify: newPasswordVerify,
          old_password: oldPassword
      )
    }
}
