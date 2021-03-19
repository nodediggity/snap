//
//  RemoteLoaderTests.swift
//  SnapTests
//
//  Created by Gordon Smith on 18/03/2021.
//

import XCTest
@testable import Snap

class RemoteLoaderTests: XCTestCase {
    
    func test_init_does_not_request_data_from_url() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requests_data_from_url() {
        let url = makeURL()
        let (sut, client) = makeSUT(requestURL: url)
        
        sut.execute { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_twice_requests_data_from_url_twice() {
        let url = makeURL()
        let (sut, client) = makeSUT(requestURL: url)
        
        sut.execute { _ in }
        sut.execute { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_delivers_error_on_client_error() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = makeError()
            client.complete(with: clientError)
        })
    }
    
    func test_load_delivers_error_on_mapper_error() {
        let error = makeError()
        let (sut, client) = makeSUT(mapper: { _, _ in
            throw error
        })
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            client.complete(withStatusCode: 200, data: makeData())
        })
    }
    
    func test_load_delivers_mapped_resource() {
        let resource = "a resource"
        let (sut, client) = makeSUT(mapper: { data, _ in
            String(data: data, encoding: .utf8)!
        })
        
        expect(sut, toCompleteWith: .success(resource), when: {
            client.complete(withStatusCode: 200, data: Data(resource.utf8))
        })
    }
    
    func test_load_does_not_deliver_result_after_instance_has_been_deallocated() {
        let url = makeURL()
        let client = HTTPClientSpy()
        var sut: RemoteLoader<String>? = RemoteLoader<String>(url, client: client, mapper: { _, _ in "any" })
        
        var capturedResults: [RemoteLoader<String>.Result] = []
        sut?.execute { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeData())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
}

private extension RemoteLoaderTests {
    func makeSUT(
        requestURL: URL? = nil,
        mapper: @escaping RemoteLoader<String>.Mapper = { _, _ in "any" },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RemoteLoader<String>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader<String>(requestURL ?? makeURL(), client: client, mapper: mapper)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    func failure(_ error: RemoteLoader<String>.Error) -> RemoteLoader<String>.Result {
        return .failure(error)
    }
    
    func expect(_ sut: RemoteLoader<String>, toCompleteWith expectedResult: RemoteLoader<String>.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "await completion")
        
        sut.execute { receivedResult in
            switch (receivedResult, expectedResult) {
                case let (.success(receivedItems), .success(expectedItems)):
                    XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                    
                case let (.failure(receivedError as RemoteLoader<String>.Error), .failure(expectedError as RemoteLoader<String>.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                    
                default:
                    XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
