//
//  RecipeGridView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI

struct RecipeGridView: View {
  @EnvironmentObject var recipeStoreManager: RecipesStore
  @Binding var searchState: SearchState
  let searchQuery: String?
  var recipeType: RecipeType

  var body: some View {
    ScrollView {
      let columns = [GridItem(.adaptive(minimum: 160, maximum: 180))]
      LazyVGrid(columns: columns, spacing: 4) {
        ForEach(
          recipeType == .tastyRecipe ?
          $recipeStoreManager.tastyRecipes :
            $recipeStoreManager.myRecipes) { recipe in
              NavigationLink {
                RecipeDetailsView(recipe: recipe
                )
                .onChange(of: recipeStoreManager.tastyRecipes.count) {
                  print("CHANGE")
                }
              } label: {
                RecipeItemView(recipe: recipe)
                  .onAppear {
                    if let searchQuery = searchQuery, recipeType == .tastyRecipe {
                      if let last = self.recipeStoreManager.tastyRecipes.last {
                        if last.id == recipe.id {
                          print("NEXT")
                          self.recipeStoreManager.nextSearch(for: searchQuery)
                          self.searchState = .additionalSearch
                        }
                      }
                    }
                  }
              }
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
}


#Preview("RecipeGridView") {
  RecipeGridView(
    searchState: .constant(.searching),
    searchQuery: "pie",
    recipeType: .tastyRecipe)
  .environmentObject(RecipesStore())
}
