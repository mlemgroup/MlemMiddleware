//
//  File.swift
//  
//
//  Created by Eric Andrews on 2024-07-03.
//
// https://stackoverflow.com/questions/34705449/how-to-print-http-request-to-console

import Foundation

extension URLRequest {
    func debug() {
        print("\(self.httpMethod!) \(self.url!)")
        print("Headers:")
        print(self.allHTTPHeaderFields!)
        print("Body:")
        print(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
    }
}
