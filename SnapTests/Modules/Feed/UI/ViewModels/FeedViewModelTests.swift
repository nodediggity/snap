//
//  FeedViewModelTests.swift
//  SnapTests
//
//  Created by Gordon Smith on 18/03/2021.
//

import XCTest
import Combine

@testable import Snap

class FeedViewModelTests: XCTestCase {

    func test_on_init_does_not_message_loader() {
        let (_, loader) = makeSUT()
        XCTAssertEqual(loader.loadFeedCount, 0)
    }
    
    func test_on_load_dispatches_load_feed_request() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadFeedCount, 0)
        
        sut.load()
        XCTAssertEqual(loader.loadFeedCount, 1)
    }
    
    func test_on_load_feed_success_delivers_successfully_loaded_feed() {
        let exp = expectation(description: "await completion")
        let feed = makeFeed()
        var (sut, loader) = makeSUT()
        
        sut.onFeedLoad = { received in
            XCTAssertEqual(received, feed)
            exp.fulfill()
        }
        
        sut.load()
        loader.loadFeedCompletes(with: .success(feed))
        wait(for: [exp], timeout: 1.0)
    }
}

private extension FeedViewModelTests {
    
    func makeSUT() -> (sut: FeedViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewModel(loader: loader.loadFeed(completion:))
        return (sut, loader)
    }
    
    class LoaderSpy {
        
        var loadFeedCount: Int {
            return requests.count
        }
        
        private var requests: [FeedLoaderCompletion] = []
        
        func loadFeed(completion: @escaping FeedLoaderCompletion) {
            requests.append(completion)
        }
        
        func loadFeedCompletes(with result: FeedLoaderResult, at index: Int = 0) {
            requests[index](result)
        }
    }
    
    func makeFeed(itemCount: Int = 5) -> [Post] {
        return (0..<itemCount).map { index in
            return Post(
                id: UUID().uuidString,
                imageURL: makeURL("https://image-\(index)"),
                likeCount: index,
                user: Post.User(id: UUID().uuidString, name: "name \(index)", imageURL:  makeURL("https://user-image-\(index)"))
            )
        }
    }
        
}
