//
//  MyTabBarController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/19/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "selectedTab.png")
        if let tintColor = tabBar.tintColor{
            let tintedImage = UITabBar.appearance().selectionIndicatorImage?.withTintColor(tintColor)
            UITabBar.appearance().selectionIndicatorImage = tintedImage
        }
    }
    
    
    
}

//extension MyTabBarController: UITabBarControllerDelegate  {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        guard let tabViewControllers = tabBarController.viewControllers, let toIndex = tabViewControllers.firstIndex(of: viewController) else {
//            return false
//        }
//        animateToTab(toIndex: toIndex)
//        return true
//    }
//
//    func animateToTab(toIndex: Int) {
//        guard let tabViewControllers = viewControllers,
//            let selectedVC = selectedViewController else { return }
//
//        guard let fromView = selectedVC.view,
//            let toView = tabViewControllers[toIndex].view,
//            let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
//            fromIndex != toIndex else { return }
//
//
//        // Add the toView to the tab bar view
//        fromView.superview?.addSubview(toView)
//
//        // Position toView off screen (to the left/right of fromView)
//        let screenWidth = UIScreen.main.bounds.size.width
//        let scrollRight = toIndex > fromIndex
//        let offset = (scrollRight ? screenWidth : -screenWidth)
//        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
//
//        // Disable interaction during animation
//        view.isUserInteractionEnabled = false
//
//        UIView.animate(withDuration: 0.3,
//                       delay: 0.0,
//                       usingSpringWithDamping: 1,
//                       initialSpringVelocity: 0,
//                       options: .curveEaseOut,
//                       animations: {
//                        // Slide the views by -offset
//                        fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
//                        toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
//
//        }, completion: { finished in
//            // Remove the old view from the tabbar view.
//            fromView.removeFromSuperview()
//            self.selectedIndex = toIndex
//            self.view.isUserInteractionEnabled = true
//        })
//    }
//}
