//
//  CustomTabBarController.swift
//  Snap
//
//  Created by Gordon Smith on 22/03/2021.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = { () -> CustomTabBar in
            let tabBar = CustomTabBar()
            tabBar.delegate = self
            return tabBar
        }()
        
        let bounds = self.tabBar.bounds
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(
            roundedRect: CGRect(x: 30, y: bounds.minY + 5, width: bounds.width - 60, height: bounds.height + 10),
            cornerRadius: 15
        ).cgPath
        
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.secondarySystemBackground.cgColor
        
        tabBar.layer.insertSublayer(layer, at: 0)
        
        tabBar.itemWidth = 45
        tabBar.itemPositioning = .centered
        
        setValue(tabBar, forKey: "tabBar")
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    class CustomTabBar: UITabBar {
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = 120
            return sizeThatFits
            
        }
    }
}
