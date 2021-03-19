//
//  Endpoints.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation

extension Endpoint {
    
    static var PAGE_SIZE: Int { 25 }
    
    static func feed(page: Int = 0, size: Int = PAGE_SIZE) -> Self {
        return .init(host: "dummyapi.io", path: ["data", "api", "post"], queryItems: ["limit": "\(size)"])
    }
}

