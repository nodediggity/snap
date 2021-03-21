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
    
    typealias Loader = () -> AnyPublisher<[Post], Error>
    typealias ImageLoader = (_: URL) -> AnyPublisher<Data, Error>
    
    static func compose(
        loader: @escaping Loader,
        imageLoader: @escaping ImageLoader
    ) -> UIViewController {
        
        let viewModel = FeedViewModel(loadFeedPublisher: loader)
        
        let rootView = FeedView(viewModel: viewModel)
            .environmentObject(ImageLoaderProvider(imageLoader))
        
        let viewController = UIHostingController(rootView: rootView)
        viewController.navigationItem.title = "Your Feed"
        return viewController
    }
}
