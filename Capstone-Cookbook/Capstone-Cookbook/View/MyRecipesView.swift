//
//  MyRecipesView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI

struct MyRecipesView: View {
  @EnvironmentObject var recipeStoreManager: RecipesStore
  var body: some View {
    NavigationStack {
      RecipeGridView(
        searchState: .constant(.none),
        searchQuery: nil,
        recipeType: .customRecipe
      )
      .navigationTitle("My Recipes")
    }
  }
}

#Preview {
  MyRecipesView()
    .environmentObject(RecipesStore())
}
