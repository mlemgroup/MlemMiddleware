//
//  BanPersonRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct BanPersonRequest: ApiPostRequest {
    typealias Body = ApiBanPerson
    typealias Response = ApiBanPersonResponse

    let path = "user/ban"
    let body: Body?

    init(
      personId: Int,
      ban: Bool,
      removeData: Bool?,
      reason: String?,
      expires: Int?
    ) {
        self.body = .init(
          person_id: personId,
          ban: ban,
          remove_data: removeData,
          reason: reason,
          expires: expires
      )
    }
}
