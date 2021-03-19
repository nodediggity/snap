//
//  FeedViewModel.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

typealias FeedLoaderCompletion = (Result<[Post], Error>) -> Void
typealias FeedLoader = ((@escaping FeedLoaderCompletion) -> Void)

struct FeedViewModel {
     
    private let loader: FeedLoader
    
    init(loader: @escaping FeedLoader) {
        self.loader = loader
    }
    
    func load() {
        loader { _ in }
    }
}
