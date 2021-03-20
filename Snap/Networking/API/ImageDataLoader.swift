//
//  ImageDataLoader.swift
//  Snap
//
//  Created by Gordon Smith on 20/03/2021.
//

import Foundation

protocol ImageDataLoaderTask {
    func cancel()
}

protocol ImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func load(imageFrom url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask
}
