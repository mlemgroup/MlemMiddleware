//
//  MlemUrlRequest.swift
//  MlemMiddleware
//
//  Created by Eric Andrews on 2025-03-12.
//

import Foundation

func mlemUrlRequest(url: URL) -> URLRequest {
    var ret = URLRequest(url: url)
    ret.setValue("MlemUserAgent", forHTTPHeaderField: "User-Agent")
    return ret
}
