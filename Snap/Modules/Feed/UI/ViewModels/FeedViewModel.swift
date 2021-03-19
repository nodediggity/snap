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
    
    typealias Observer<T> = (T) -> Void
     
    @Published var onFeedLoad: Observer<[Post]>?
    @Published var onLoadingStateChange: Observer<Bool>?

    private let loader: Loader
    
    init(loader: @escaping Loader) {
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
