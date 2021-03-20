//
//  CombineHelpers.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation
import Combine

// MARK:- HTTPClient
extension HTTPClient {
    typealias Publisher = AnyPublisher<(data: Data, response: HTTPURLResponse), Error>
    
    func dispatchPublisher(for request: URLRequest) -> Publisher {
        var task: HTTPClientTask?
        
        return Deferred {
            Future { completion in
                task = self.dispatch(request, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

// MARK:- ImageDataLoader
extension ImageDataLoader {
    typealias Publisher = AnyPublisher<Data, Error>
    func loadImageDataPublisher(from url: URL) -> Publisher {
        var task: ImageDataLoaderTask?
        return Deferred {
            Future { completion in
                task = self.load(imageFrom: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

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

// MARK:- AsyncImageViewModel
extension AsyncImageViewModel {
    typealias Publisher = AnyPublisher<Data, Error>
    convenience init(imageURL: URL, loadImagePublisher publisher: @escaping (URL) -> Publisher, imageTransformer: @escaping (Data) -> Image?) {
        self.init(imageURL: imageURL, loader: { url, completion in
            
            var cancellable: AnyCancellable?
            
            let task = ImageDataLoaderTaskWrapper(completion)
   
            cancellable = publisher(imageURL)
                .handleEvents(receiveCancel: { task.cancel() })
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            task.complete(with: .failure(error))
                        }
                        cancellable?.cancel()
                        cancellable = nil
                        task.cancel()
                    },
                    receiveValue: { imageData in task.complete(with: .success(imageData)) }
                )
   
            task.onCancel = cancellable?.cancel
            
            return task
            
        }, imageTransformer: imageTransformer)
    }
    
    private class ImageDataLoaderTaskWrapper: ImageDataLoaderTask {
        
        var wrapped: ImageDataLoaderTask?
        var onCancel: (() -> Void)?
        
        private var completion: ((ImageDataLoader.Result) -> Void)?
        
        init(_ completion: @escaping (ImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: ImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
            onCancel?()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
}


// MARK:- Threading
extension Publisher {
    func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueScheduler {
        ImmediateWhenOnMainQueueScheduler.shared
    }
    
    struct ImmediateWhenOnMainQueueScheduler: Scheduler {
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        var now: SchedulerTimeType {
            DispatchQueue.main.now
        }
        
        var minimumTolerance: SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }
        
        static let shared = Self()
        
        private static let key = DispatchSpecificKey<UInt8>()
        private static let value = UInt8.max
        
        private init() {
            DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
        }
        
        private func isMainQueue() -> Bool {
            DispatchQueue.getSpecific(key: Self.key) == Self.value
        }
        
        func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
            guard isMainQueue() else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            
            action()
        }
        
        func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }
        
        func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}

