//
//  RemoteLoader.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

final class RemoteLoader<Resource> {
    private let requestURL: URL
    private let client: HTTPClient
    private let mapper: Mapper
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    typealias Result = Swift.Result<Resource, Swift.Error>
    typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    
    init(_ requestURL: URL, client: HTTPClient, mapper: @escaping Mapper) {
        self.requestURL = requestURL
        self.client = client
        self.mapper = mapper
    }
    
    func execute(_ completion: @escaping (Result) -> Void) {
        let request = URLRequest(url: requestURL)
        client.dispatch(request) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case let .success((data, response)):
                    completion(self.map(data, from: response))
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }
}

private extension RemoteLoader {
    func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            return .success(try mapper(data, response))
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
