//
//  NewApiClient+Site.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation

public extension ApiClient {
    func getMyInstance() async throws -> Instance3 {
        let request = GetSiteRequest()
        let response = try await perform(request)
        var model = caches.instance3.getModel(api: self, from: response)
        model.local = true
        myInstance = model
        return model
    }
}
