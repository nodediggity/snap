//
//  AsyncImageViewModel.swift
//  Snap
//
//  Created by Gordon Smith on 20/03/2021.
//

import Foundation

final class AsyncImageViewModel<Image>: ObservableObject where Image: Equatable {

    typealias LoaderResult = Result<Data, Error>
    typealias LoaderCompletion = (LoaderResult) -> Void
    typealias Loader = (URL, @escaping LoaderCompletion) -> ImageDataLoaderTask
    
    @Published var state: ViewState<Image> = .loading

    private var imageURL: URL
    private let loader: Loader
    
    private var imageTransformer: (Data) -> Image?
    
    private var task: ImageDataLoaderTask?
        
    init(imageURL: URL, loader: @escaping Loader, imageTransformer: @escaping (Data) -> Image?) {
        self.imageURL = imageURL
        self.loader = loader
        self.imageTransformer = imageTransformer
    }
    
    func loadImage() {
        state = .loading
        task = loader(imageURL) { [weak self] in self?.handle($0) }
    }
    
    func cancel() {
        task?.cancel()
        task = nil
    }
}

private extension AsyncImageViewModel {
    func handle(_ result: LoaderResult) {
        
        if let image = (try? result.get()).flatMap(imageTransformer) {
            state = .loaded(image)
        } else {
            state = .error(message: "uh oh, something went wrong")
        }
        
    }
}
