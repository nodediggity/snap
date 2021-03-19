//
//  SceneDelegate.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = FeedUIComposer.compose()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

