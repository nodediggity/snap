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
}

private extension FeedViewModelTests {
    
    func makeSUT() -> (sut: FeedViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewModel()
        return (sut, loader)
    }
    
    class LoaderSpy {
        
        var loadFeedCount: Int {
            return 0
        }
        
    }
        
}
