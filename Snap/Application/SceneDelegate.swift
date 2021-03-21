//
//  SceneDelegate.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import UIKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var APP_ID: String { "605448f84977a585e87b67f8" }
    private var APP_ID_KEY: String { "app-id" }
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: .init(configuration: .ephemeral))
    }()
    
    private lazy var navController = UINavigationController(rootViewController: makeFeedScene())
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            window.rootViewController = navController
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

private extension SceneDelegate {
        
    // MARK:- Loaders
    func makeFeedLoader() -> AnyPublisher<[Post], Error> {
        var request = URLRequest(endpoint: .feed())
        request.addValue(APP_ID, forHTTPHeaderField: APP_ID_KEY)
        
        return httpClient
            .dispatchPublisher(for: request)
            .tryMap(FeedMapper.map)
            .dispatchOnMainQueue()
            .eraseToAnyPublisher()
    }
    
    func makeImageLoader(_ imageURL: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: imageURL)
        request.addValue(APP_ID, forHTTPHeaderField: APP_ID_KEY)
        
        return httpClient
            .dispatchPublisher(for: request)
            .tryMap(ImageDataMapper.map)
            .dispatchOnMainQueue()
            .eraseToAnyPublisher()
    }
    
    // MARK:- Scenes
    func makeFeedScene() -> UIViewController {
        return FeedUIComposer.compose(
            loader: makeFeedLoader,
            imageLoader: makeImageLoader
        )
    }
}
