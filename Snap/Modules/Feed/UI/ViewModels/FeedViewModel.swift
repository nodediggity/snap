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

struct FeedViewModel {
     
    var onFeedLoad: (([Post]) -> Void)?
    
    private let loader: FeedLoader
    
    init(loader: @escaping FeedLoader) {
        self.loader = loader
    }
    
    func load() {
        loader { result in
            if let feed = try? result.get() {
                onFeedLoad?(feed)
            }
        }
    }
}
