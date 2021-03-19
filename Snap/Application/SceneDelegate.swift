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
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: .init(configuration: .ephemeral))
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = FeedUIComposer.compose(loader: makeFeedLoader)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

private extension SceneDelegate {
        
    // MARK:- Loaders
    func makeFeedLoader() -> AnyPublisher<[Post], Error> {
        var request = URLRequest(endpoint: .feed())
        request.addValue(APP_ID, forHTTPHeaderField: "app-id")
        return httpClient
            .dispatchPublisher(for: request)
            .tryMap(FeedMapper.map)
            .dispatchOnMainQueue()
            .eraseToAnyPublisher()
    }
}

