//
//  Capstone_CookbookApp.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import SwiftUI

@main
struct CapstoneCookbookApp: App {
  @StateObject var recipeStoreManager = RecipesStore()
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(recipeStoreManager)
    }
  }
}
