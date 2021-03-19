//
//  FeedUIComposer.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import UIKit
import SwiftUI

enum FeedUIComposer {
    static func compose() -> UIHostingController<FeedListView> {
        let rootView = FeedListView()
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
}
