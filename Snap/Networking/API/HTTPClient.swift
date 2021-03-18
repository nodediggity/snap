//
//  HTTPClient.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Result = Swift.Result<(data: Data, response: HTTPURLResponse), Error>
    
    @discardableResult
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func dispatch(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
