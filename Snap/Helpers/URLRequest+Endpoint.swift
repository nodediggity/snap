//
//  URLRequest+Endpoint.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation

extension URLRequest {
    init(endpoint: Endpoint) {
        self.init(url: endpoint.url)
    }
}
