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
        
        
        //        UITabBar.appearance().barTintColor = UIColor.black
    }
    
    //    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    //
    //        if let fromView = tabBarController.selectedViewController?.view,
    //            let toView = viewController.view, fromView != toView,
    //            let controllerIndex = self.viewControllers?.firstIndex(of: viewController) {
    //
    //            let viewSize = fromView.frame
    //            let scrollRight = controllerIndex > tabBarController.selectedIndex
    //
    //            // Avoid UI issues when switching tabs fast
    //            if fromView.superview?.subviews.contains(toView) == true { return false }
    //
    //            fromView.superview?.addSubview(toView)
    //
    //            let screenWidth = UIScreen.main.bounds.size.width
    //            toView.frame = CGRect(x: (scrollRight ? screenWidth : -screenWidth), y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
    //
    //            UIView.animate(withDuration: 0.25, delay: TimeInterval(0.0), options: [.curveEaseOut, .preferredFramesPerSecond60], animations: {
    //                fromView.frame = CGRect(x: (scrollRight ? -screenWidth : screenWidth), y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
    //                toView.frame = CGRect(x: 0, y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
    //            }, completion: { finished in
    //                if finished {
    //                    fromView.removeFromSuperview()
    //                    tabBarController.selectedIndex = controllerIndex
    //                }
    //            })
    //            return true
    //        }
    //        return false
    //    }
    
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
