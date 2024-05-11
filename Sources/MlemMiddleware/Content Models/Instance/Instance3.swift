//
//  Instance3.swift
//  Mlem
//
//  Created by Sjmarf on 12/02/2024.
//

import Foundation
import SwiftUI

@Observable
public final class Instance3: Instance3Providing {
    public var api: ApiClient
    public var instance3: Instance3 { self }
    
    public let instance2: Instance2
    
    public var version: SiteVersion
  
    internal init(api: ApiClient, instance2: Instance2, version: SiteVersion) {
        self.api = api
        self.instance2 = instance2
        self.version = version
    }
}
