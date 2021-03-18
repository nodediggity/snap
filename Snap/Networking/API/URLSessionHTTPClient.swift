//
//  URLSessionHTTPClient.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
        
    init(session: URLSession) {
        self.session = session
    }
    
    func dispatch(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}

private extension URLSessionHTTPClient {
    
    struct UnexpectedValuesRepresentation: Error { }
    
    struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
}

