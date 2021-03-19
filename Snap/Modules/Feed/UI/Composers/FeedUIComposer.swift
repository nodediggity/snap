//
//  FeedUIComposer.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import UIKit
import SwiftUI
import Combine

enum FeedUIComposer {
    static func compose(loader: @escaping () -> AnyPublisher<[Post], Error>) -> UIHostingController<FeedListView> {
        
        let viewModel = FeedViewModel(loadFeedPublisher: loader)
        let rootView = FeedListView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
}
