//
//  GetSiteMetadataRequest.swift
//  Mlem
//
//  Created by Eric Andrews on 2024-04-27
//

// ---- AUTOMATICALLY GENERATED FILE, DO NOT MODIFY ---- //

import Foundation

struct GetSiteMetadataRequest: ApiGetRequest {
    typealias Response = ApiGetSiteMetadataResponse

    let path = "post/site_metadata"
    let queryItems: [URLQueryItem]

    init(
      url: String
    ) {
        self.queryItems = [
            .init(name: "url", value: url)
        ]
    }
}
