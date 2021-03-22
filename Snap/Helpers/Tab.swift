//
//  Tab.swift
//  Snap
//
//  Created by Gordon Smith on 22/03/2021.
//

import UIKit

enum Tabs: CaseIterable {
    
    case feed
    case alerts
    case messages
    case profile
    
    var icon: UIImage? {
        switch self {
            case .feed: return UIImage(named: "feed_icon")?.resized(to: .init(width: 32, height: 32))
            case .alerts: return UIImage(named: "notification_icon")?.resized(to: .init(width: 32, height: 32))
            case .messages: return UIImage(named: "messages_icon")?.resized(to: .init(width: 32, height: 32))
            case .profile: return UIImage(named: "user_icon")?.resized(to: .init(width: 32, height: 32))
        }
    }
}
