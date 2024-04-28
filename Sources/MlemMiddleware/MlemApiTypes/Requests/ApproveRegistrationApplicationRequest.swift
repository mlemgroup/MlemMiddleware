//
//  ApproveRegistrationApplicationRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct ApproveRegistrationApplicationRequest: ApiPutRequest {
    typealias Body = ApiApproveRegistrationApplication
    typealias Response = ApiRegistrationApplicationResponse

    let path = "admin/registration_application/approve"
    let body: Body?

    init(
      id: Int,
      approve: Bool,
      denyReason: String?
    ) {
        self.body = .init(
          id: id,
          approve: approve,
          deny_reason: denyReason
      )
    }
}
