//
//  MyUser.swift
//  Mlem
//
//  Created by Sjmarf on 13/02/2024.
//

import Foundation
import SwiftUI

@Observable
public final class User: Person3Providing, UserProviding {
    public var api: ApiClient
    
    public static let identifierPrefix: String = "@"
    
    public let stub: UserStub
    public let person3: Person3
    public let instance: Instance3
    public var id: Int { person3.id }
    public var name: String { stub.name }
  
    public init(api: ApiClient, stub: UserStub, person3: Person3, instance: Instance3) {
        self.api = api
        self.stub = stub
        self.person3 = person3
        self.instance = instance
    }
}
