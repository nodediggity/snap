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
        let feed = makeFeed()
        let (sut, loader) = makeSUT()
        
        sut.onFeedLoad = { received in
            XCTAssertEqual(received, feed)
        }
        
        sut.load()
        loader.loadFeedCompletes(with: .success(feed))
    }
    
    func test_load_does_not_deliver_result_after_instance_has_been_deallocated() {
        let loader = LoaderSpy()
        let feed = makeFeed()
        var sut: FeedViewModel? = FeedViewModel(loadFeedPublisher: loader.loadFeedPublisher)

        var output: [Any] = []
        sut?.onFeedLoad = { output.append($0) }
        sut?.load()
        sut = nil

        loader.loadFeedCompletes(with: .success(feed))
        XCTAssertTrue(output.isEmpty)
     }
    
    func test_on_load_feed_notifies_clients_of_loading_state_change() {
        let feed = makeFeed()
        let (sut, loader) = makeSUT()
        
        var output: [Bool] = []
        sut.onLoadingStateChange = { output.append($0) }
            
        sut.load()
        loader.loadFeedCompletes(with: .success(feed))
        XCTAssertEqual(output, [true, false])
    }
}

private extension FeedViewModelTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewModel(loadFeedPublisher: loader.loadFeedPublisher)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy {
        
        var loadFeedCount: Int {
            return requests.count
        }
        
        private var requests: [PassthroughSubject<[Post], Error>] = []
        
        func loadFeedPublisher() -> AnyPublisher<[Post], Error> {
            let publisher = PassthroughSubject<[Post], Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func loadFeedCompletes(with result: FeedViewModel.LoaderResult, at index: Int = 0) {
            switch result {
                case let .success(feed):
                    requests[index].send(feed)
                    requests[index].send(completion: .finished)
                default: break
            }
        }
        
//        var loadFeedCount: Int {
//            return requests.count
//        }
//
//        private var requests: [FeedViewModel.LoaderCompletion] = []
//
//        func loadFeed(completion: @escaping FeedViewModel.LoaderCompletion) {
//            requests.append(completion)
//        }
//
//        func loadFeedCompletes(with result: FeedViewModel.LoaderResult, at index: Int = 0) {
//            requests[index](result)
//        }
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
