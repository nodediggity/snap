//
//  FeedSnapshotTests.swift
//  SnapTests
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation
import Combine
import XCTest
import SwiftUI

@testable import Snap

class FeedSnapshotTests: XCTestCase {
    
    func test_feed_with_content() {
        let content = feedWithContent
        let viewModel = FeedViewModel(loader: { $0(.success(content)) })
        let sut = makeSUT(viewModel: viewModel)
        sut.view.enforceLayoutCycle()
        viewModel.loadFeed()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_CONTENT_dark")
        executeRunLoopToCleanUpReferences()
    }
}

private extension FeedSnapshotTests {
    func makeSUT(viewModel: FeedViewModel) -> UIViewController {
        let rootView = FeedView(viewModel: viewModel)
            .environmentObject(ImageLoaderProvider(makeImageLoader))
        let controller = UIHostingController(rootView: rootView)
        controller.loadViewIfNeeded()
        return controller
    }
    
    var feedWithContent: [Post] {
        return [
            Post(
                id: "id-1",
                imageURL: makeURL("https://image.com/card-image-1"),
                likeCount: 25,
                user: .init(id: "any", name: "Some Name", imageURL: makeURL("https://image.com/user-image-1"))
            ),
            Post(
                id: "id-2",
                imageURL: makeURL("https://image.com/card-image-2"),
                likeCount: 34,
                user: .init(id: "any", name: "Some'Other Name", imageURL: makeURL("https://image.com/user-image-2"))
            )
        ]
    }
    
    func makeImageLoader(_ url: URL) -> AnyPublisher<Data, Error> {
        let data: Data = makeImageData(for: url) ?? Data()
        return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func makeImageData(for imageURL: URL) -> Data? {
        switch imageURL.path {
            case "/card-image-1": return UIImage.makeImageData(withColor: .red)
            case "/user-image-1": return UIImage.makeImageData(withColor: .blue)
            case "/card-image-2": return UIImage.makeImageData(withColor: .systemTeal)
            case "/user-image-3": return UIImage.makeImageData(withColor: .green)
            default: return .none
        }
    }
}

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.main.run(until: Date())
    }
}

private func executeRunLoopToCleanUpReferences() {
    RunLoop.current.run(until: Date())
}
