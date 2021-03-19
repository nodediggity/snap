//
//  FeedViewModel.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

typealias FeedLoaderResult = Result<[Post], Error>
typealias FeedLoaderCompletion = (FeedLoaderResult) -> Void
typealias FeedLoader = ((@escaping FeedLoaderCompletion) -> Void)

class FeedViewModel {
    
    typealias Observer<T> = (T) -> Void
     
    var onFeedLoad: Observer<[Post]>?
    var onLoadingStateChange: Observer<Bool>?

    private let loader: FeedLoader
    
    init(loader: @escaping FeedLoader) {
        self.loader = loader
    }
    
    func load() {
        onLoadingStateChange?(true)
        loader { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
