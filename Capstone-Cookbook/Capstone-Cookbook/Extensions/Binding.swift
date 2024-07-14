//
//  Binding.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 12/07/2024.
//

import SwiftUI

// Code from `https://alanquatermain.me/programming/swiftui/2019-11-15-CoreData-and-bindings/`
//extension Binding {
//  init(_ source: Binding<Value?>, _ defaultValue: Value) {
//    // Ensure a non-nil value in source
//    if source.wrappedValue == nil {
//      source.wrappedValue = defaultValue
//    }
//    // We already know it's non-nil, so we can *unsafe unwrap* it
//    // swiftlint:disable:next force_unwrapping
//    self.init(source)!
//  }
//
//  init(_ source: Binding<Value?>, replacingNilWith nilValue: Value) {
//    self.init(
//      get: { source.wrappedValue ?? nilValue },
//      set: { newValue in
//        if newValue == nilValue {
//          source.wrappedValue = nil
//        } else {
//          source.wrappedValue = newValue
//        }
//      })
//  }

//  init<T>(isNotNil source: Binding<T?>, defaultValue: T) where Value == Bool {
//    self.init(
//      get: { source.wrappedValue != nil },
//      set: { source.wrappedValue = $0 ? defaultValue : nil })
//  }
//}
