//
//  MyRecipesView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI

struct MyRecipesView: View {
  @EnvironmentObject var recipeStoreManager: RecipesStore
  @Binding var tabSelection: Int
  var body: some View {
    NavigationStack {
      ZStack {
        if !recipeStoreManager.myRecipes.isEmpty {
          RecipeGridView(
            searchState: .constant(.none),
            searchQuery: nil,
            recipeType: .myRecipe
          )
        } else {
          EmptyCookBook(tabSelection: $tabSelection)
        }
      }
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
  MyRecipesView(tabSelection: .constant(1))
    .environmentObject(RecipesStore())
}
