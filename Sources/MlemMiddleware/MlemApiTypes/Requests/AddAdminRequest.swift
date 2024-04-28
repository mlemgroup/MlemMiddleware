//
//  AddAdminRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct AddAdminRequest: ApiPostRequest {
    typealias Body = ApiAddAdmin
    typealias Response = ApiAddAdminResponse

    let path = "admin/add"
    let body: Body?

    init(
      personId: Int,
      added: Bool
    ) {
        self.body = .init(
          person_id: personId,
          added: added
      )
    }
}
