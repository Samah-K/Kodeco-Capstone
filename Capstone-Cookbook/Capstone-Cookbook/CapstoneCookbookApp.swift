//
//  Capstone_CookbookApp.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import SwiftUI

@main
struct CapstoneCookbookApp: App {
  @AppStorage("isOnboarding")
  var isOnBoarding = false
  @StateObject var recipeStoreManager = RecipesStore()

  var body: some Scene {
    WindowGroup {
      if isOnBoarding {
        ContentView()
          .environmentObject(recipeStoreManager)
      } else {
        OnboardingView()
      }
    }
  }
}
