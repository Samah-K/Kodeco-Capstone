//
//  File.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 19/07/2024.
//

import SwiftUI

// Code taken form: https://sarunw.com/posts/sfsafariviewcontroller-in-swiftui/
extension UIApplication {
  var firstKeyWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first { $0.activationState == .foregroundActive }?
      .keyWindow
  }
}
