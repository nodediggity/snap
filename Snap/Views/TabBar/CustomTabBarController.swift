//
//  CustomTabBarController.swift
//  Snap
//
//  Created by Gordon Smith on 22/03/2021.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    
    var onTapButton: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = { () -> CustomTabBar in
            let tabBar = CustomTabBar()
            tabBar.onTapButton = onTapButton
            tabBar.delegate = self
            return tabBar
        }()
        
        let bounds = self.tabBar.bounds
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(
            roundedRect: CGRect(x: 20, y: bounds.minY + 5, width: bounds.width - 40, height: bounds.height + 10),
            cornerRadius: 15
        ).cgPath
        
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.secondarySystemBackground.cgColor
        
        tabBar.layer.insertSublayer(layer, at: 0)
        
        tabBar.itemWidth = 60
        tabBar.itemPositioning = .centered
        
        setValue(tabBar, forKey: "tabBar")
            
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    class CustomTabBar: UITabBar {
        
        var onTapButton: (() -> Void)?
  
        private lazy var button: UIButton = {
            let button = UIButton()
            button.frame.size = CGSize(width: 70, height: 70)
            button.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
            button.layer.cornerRadius = 35
            button.layer.masksToBounds = true
            button.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.setImage(UIImage(named: "photo_icon")?.withTintColor(.white).resized(to: .init(width: 32, height: 32)), for: .normal)
            addSubview(button)
            return button
        }()

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = 120
            return sizeThatFits
        }

        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard !self.isHidden else { return super.hitTest(point, with: event) }
            
            let from = point
            let to = button.center
            return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 39
                ? button
                : super.hitTest(point, with: event)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            button.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 12)
        }

        @objc func buttonTapped() {
            onTapButton?()
        }
}
}
