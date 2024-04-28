//
//  PurgePersonRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct PurgePersonRequest: ApiPostRequest {
    typealias Body = ApiPurgePerson
    typealias Response = ApiSuccessResponse

    let path = "admin/purge/person"
    let body: Body?

    init(
      personId: Int,
      reason: String?
    ) {
        self.body = .init(
          person_id: personId,
          reason: reason
      )
    }
}
