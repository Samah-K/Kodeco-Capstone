//
//  MyRecipesView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI

struct MyRecipesView: View {
  @ObservedObject var recipeStoreManager: RecipeStoresManager
  var body: some View {
    NavigationStack {
      RecipeGridView(
        recipeStoreManager: recipeStoreManager,
        searchState: .constant(.none),
        searchQuery: nil,
        recipeType: .customRecipe
      )
      .navigationTitle("My Recipes")
    }
  }
}

#Preview {
  MyRecipesView(recipeStoreManager: RecipeStoresManager())
}
