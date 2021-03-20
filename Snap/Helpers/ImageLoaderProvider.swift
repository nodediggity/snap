//
//  ImageLoaderProvider.swift
//  Snap
//
//  Created by Gordon Smith on 20/03/2021.
//

import Foundation
import Combine

class ImageLoaderProvider: ObservableObject {
    
    private var loader: (_ imageURL: URL) -> AnyPublisher<Data, Error>
    
    init(_ loader: @escaping (_ imageURL: URL) -> AnyPublisher<Data, Error>) {
        self.loader = loader
    }
    
    func make() -> (_ imageURL: URL) -> AnyPublisher<Data, Error> {
        return loader
    }
}
