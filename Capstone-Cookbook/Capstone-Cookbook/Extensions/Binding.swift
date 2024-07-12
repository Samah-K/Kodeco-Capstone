//
//  Binding.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 12/07/2024.
//

import SwiftUI

// Code from `https://alanquatermain.me/programming/swiftui/2019-11-15-CoreData-and-bindings/`
extension Binding {
  init(_ source: Binding<Value?>, _ defaultValue: Value) {
    // Ensure a non-nil value in source
    if source.wrappedValue == nil {
      source.wrappedValue = defaultValue
    }
    // We already know it's non-nil, so we can *unsafe unwrap* it
    // swiftlint:disable:next force_unwrapping
    self.init(source)!
  }
}
