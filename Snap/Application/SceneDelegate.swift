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
    
    private var APP_ID: String { Constants.API_KEY }
    private var APP_ID_KEY: String { Constants.API_ID }
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: .init(configuration: .ephemeral))
    }()
    
    private lazy var navController: UINavigationController = {
        let controller = UINavigationController(rootViewController: makeHomeScene())
        controller.navigationBar.isHidden = true
        return controller
    }()
    
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
    func makeHomeScene() -> UITabBarController {
        let tabBarController = CustomTabBarController()
        tabBarController.viewControllers = makeTabs(tabs: [.feed, .alerts, .messages, .profile])
        
        tabBarController.tabBar.tintColor = #colorLiteral(red: 0.2431372549, green: 0.6705882353, blue: 0.3607843137, alpha: 1)
        tabBarController.tabBar.unselectedItemTintColor = .secondaryLabel

        return tabBarController
    }
    
    func makeFeedScene() -> UIViewController {
        return FeedUIComposer.compose(
            loader: makeFeedLoader,
            imageLoader: makeImageLoader
        )
    }
    
    func makeTabs(tabs: [Tabs]) -> [UINavigationController] {
        let navControllers = tabs.indices
            .map { index -> UINavigationController in
                let tab = tabs[index]
                let navController = UINavigationController()
                navController.tabBarItem = .init(title: nil, image: tab.icon, selectedImage: nil)
                
                navController.tabBarItem.imageInsets = {
                    switch index {
                        case 0: return .init(top: 0, left: -32, bottom: 6, right: 0)
                        case 1: return .init(top: 0, left: -48, bottom: 6, right: 0)
                        case 2: return .init(top: 0, left: 0, bottom: 6, right: -56)
                        case 3: return .init(top: 0, left: 0, bottom: 6, right: -36)
                        default: return .zero
                    }
                }()
                                                
                return navController
            }
        
        return zip(tabs, navControllers).map { (tab, navController) in
            switch tab {
                case .feed: navController.setViewControllers([makeFeedScene()], animated: false)
                default: navController.setViewControllers([
                    UIHostingController(rootView: Text("🍕"))
                ], animated: false)
            }
            return navController
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
