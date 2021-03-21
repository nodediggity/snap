//
//  FeedSnapshotTests.swift
//  SnapTests
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation
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
        executeRunLoopToCleanUpReferences()
    }
}

private extension FeedSnapshotTests {
    func makeSUT(viewModel: FeedViewModel) -> UIViewController {
        let rootView = FeedView(viewModel: viewModel)
        let controller = UIHostingController(rootView: rootView)
        controller.loadViewIfNeeded()
        return controller
    }
    
    
    var feedWithContent: [Post] {
        return [
            Post(id: "id 1", imageURL: makeURL(), likeCount: 25, user: .init(id: UUID().uuidString, name: "Some Name", imageURL: makeURL())),
            Post(id: "id 2", imageURL: makeURL(), likeCount: 34, user: .init(id: UUID().uuidString, name: "Some'Other Name", imageURL: makeURL()))
        ]
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
