//
//  CombineHelpers.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation
import Combine

// MARK:- FeedViewModel
extension FeedViewModel {
    convenience init(loadFeedPublisher publisher: @escaping () -> AnyPublisher<[Post], Error>) {
        self.init(loader: { completion in
            publisher().subscribe(Subscribers.Sink(
                receiveCompletion: { _ in  },
                receiveValue: { result in completion(.success(result)) }
            ))
        })
    }
}
