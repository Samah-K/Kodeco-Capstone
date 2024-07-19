//
//  RecipeGridView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI

//struct RecipeListView: View {
//  @EnvironmentObject var recipeStoreManager: RecipesStore
//  @Binding var searchState: SearchState
//  let searchQuery: String?
//  var recipeType: RecipeType
//
//  var body: some View {
//    ScrollView {
//      ForEach(
//        recipeType == .tastyRecipe ?
//        $recipeStoreManager.tastyRecipes :
//          $recipeStoreManager.myRecipes) { recipe in
//            NavigationLink {
//              RecipeDetailsView(recipe: recipe.wrappedValue, addFavoriteButton: true)
//            } label: {
//              RecipeItemView(recipe: recipe)
//                .frame(height: ViewConstants.minListHeight)
//                .padding()
//            }
//            Divider()
//              .padding(.horizontal, 20)
//      }
//    }
//  }
//}

struct RecipeGridView: View {
  @EnvironmentObject var recipeStoreManager: RecipesStore
  @Binding var searchState: SearchState
  let searchQuery: String?
  var recipeType: RecipeType
  @Environment(\.verticalSizeClass)
  var verticalSizeClass
  @Environment(\.horizontalSizeClass)
  var horizontalSizeClass

  var body: some View {
    ScrollView {
      let isPortraitMode = verticalSizeClass == .regular && horizontalSizeClass == .compact
        let twoColumns = [
          GridItem(.flexible()),
          GridItem(.flexible())
        ]

      let oneColumns = [
        GridItem(.flexible())
      ]
      LazyVGrid(columns: isPortraitMode ? oneColumns : twoColumns, spacing: 4) {
        ForEach(
          recipeType == .tastyRecipe ?
          $recipeStoreManager.tastyRecipes :
            $recipeStoreManager.myRecipes) { recipe in
              NavigationLink {
                RecipeDetailsView(recipe: recipe.wrappedValue)
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
      .frame(maxWidth: .infinity)
    }
  }
}


#Preview("RecipeGridView") {
  RecipeGridView(
    searchState: .constant(.searching),
    searchQuery: "pie",
    recipeType: .myRecipe)
  .environmentObject(RecipesStore())
}

//#Preview("RecipeListView") {
//  struct Preview: View {
//    var body: some View {
//      RecipeListView(
//        searchState: .constant(.searching),
//        searchQuery: "pie",
//        recipeType: .myRecipe)
//      .environmentObject(RecipesStore())
//    }
//  }
//  return Preview()
//}
