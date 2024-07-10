//
//  RecipeGridView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI

struct RecipeGridView: View {
  @ObservedObject var recipeStoreManager: RecipeStoresManager
  @Binding var searchState: SearchState
  let searchQuery: String?
  var recipeType: RecipeType

  var body: some View {
    ScrollView {
      let columns = [GridItem(.adaptive(minimum: 160, maximum: 180))]
      LazyVGrid(columns: columns, spacing: 4) {
        ForEach(recipeType == .tastyRecipe ?
                  $recipeStoreManager.tastyStore.tastyRecipes :
                  $recipeStoreManager.myRecipesStore.myRecipes) { recipe in
          //        ForEach(recipes) { recipe in
          NavigationLink {
            RecipeDetailsView(
              recipeStoreManager: recipeStoreManager,
              recipe: recipe
            )
          } label: {
            RecipeItemView(
              recipeStoreManager: recipeStoreManager, recipe: recipe)
            //            .onAppear {
            //              if let searchQuery = searchQuery {
            //                if let last = self.recipeStoreManager.tastyStore.tastyRecipes.last {
            //                  if last.id == recipe.id {
            //                    print("NEXT")
            //                    self.recipeStoreManager.nextSearch(for: searchQuery)
            //                    self.searchState = .additionalSearch
            //                  }
            //                }
            //              }
            //            }
          }
        }
      }
      //      .onChange(of: recipeStoreManager.count) {
      //        print("Changed")
      //      }
      .onChange(of: recipeStoreManager.tastyStore.tastyRecipes) {
        print("tastyRecipes Changed")
      }

      //      .onReceive(recipeStoreManager.tastyStore.$tastyRecipes) { recipe in
      //        print(recipe)
      //        print("ON RECEIVED")
      //      }
    }
    .frame(maxWidth: .infinity)
  }
}


#Preview("RecipeGridView") {
  RecipeGridView(
    recipeStoreManager: RecipeStoresManager(),
    searchState: .constant(.searching),
    searchQuery: "pie",
    recipeType: .tastyRecipe)
}
