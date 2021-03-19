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

    }
        
}
