//
//  NavigationExtension.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import UIKit
// Solution found here: https://moussahellal.medium.com/swipe-back-gesture-for-custom-navigation-in-swiftui-5eaa3ec8d05a
extension UINavigationController: UIGestureRecognizerDelegate {
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }

  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
