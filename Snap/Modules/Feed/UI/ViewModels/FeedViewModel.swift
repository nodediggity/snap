//
//  FeedViewModel.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

final class FeedViewModel: ObservableObject {
    
    typealias LoaderResult = Result<[Post], Error>
    typealias LoaderCompletion = (LoaderResult) -> Void
    typealias Loader = ((@escaping LoaderCompletion) -> Void)
         
    @Published var feed: [Post] = []
    @Published var isLoading: Bool = false

    private let loader: Loader
    
    init(loader: @escaping Loader) {
        self.loader = loader
    }
    
    func loadFeed() {
        isLoading = true
        loader { [weak self] result in
            if let feed = try? result.get() {
                self?.feed = feed
            }
            self?.isLoading = false
        }
    }
}
