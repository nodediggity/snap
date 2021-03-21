//
//  FeedUIIntegrationTests.swift
//  SnapTests
//
//  Created by Gordon Smith on 21/03/2021.
//

import XCTest
import SwiftUI
import Combine

@testable import Snap

class FeedUIIntergrationTests: XCTestCase {
    
    func test_renders_view_with_title() {
        let sut = makeSUT()
        XCTAssertEqual(sut.navigationItem.title, "Your Feed")
    }
}
private extension FeedUIIntergrationTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> UIViewController {
        let sut = FeedUIComposer.compose(
            loader: { PassthroughSubject<[Post], Error>().eraseToAnyPublisher() },
            imageLoader: { _ in PassthroughSubject<Data, Error>().eraseToAnyPublisher() }
        )

        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
}
