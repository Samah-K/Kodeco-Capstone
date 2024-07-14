//
//  MyRecipesView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI

struct MyRecipesView: View {
//  @EnvironmentObject var recipeStoreManager: RecipesStore
  var body: some View {
    NavigationStack {
      RecipeGridView(
        searchState: .constant(.none),
        searchQuery: nil,
        recipeType: .myRecipe
      )
      .navigationTitle("My Recipes")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink {
            var recipe = Recipe(tastyRecipe: nil, recipeType: RecipeType.myRecipe)
            var recipeBinding: Binding<Recipe> {
              Binding(
                get: { recipe },
                set: { recipe = $0 }
              )
            }
            AddRecipeView(recipe: recipeBinding)
          } label: {
            HStack {
              Image(systemName: "plus")
              Text("New Recipe")
            }
          }
        }
      }
    }
  }
}

#Preview {
  MyRecipesView()
}
