//
//  Endpoint.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

struct Endpoint {
    var host: String
    var path: [String]
    var queryItems: KeyValuePairs<String, String> = [:]
    init(host: String, path: [String] = [], queryItems: KeyValuePairs<String, String> = [:]) {
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}

extension Endpoint {
    
    var url: URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        
        if !path.isEmpty {
            components.path = "/" + path.joined(separator: "/")
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}
