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
