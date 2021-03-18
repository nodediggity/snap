//
//  RemoteLoader.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

final class RemoteLoader<Resource> {
    private let client: HTTPClient
    private let mapper: Mapper
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    typealias Result = Swift.Result<Resource, Swift.Error>
    typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    
    init(client: HTTPClient, mapper: @escaping Mapper) {
        self.client = client
        self.mapper = mapper
    }
    
    func execute(_ request: URLRequest, completion: @escaping (Result) -> Void) {
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
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            return .success(try mapper(data, response))
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
