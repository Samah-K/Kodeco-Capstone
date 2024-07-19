//
//  ExploreRecipesView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 09/07/2024.
//

import SwiftUI


struct ExploreRecipesView: View {
  @EnvironmentObject var recipeStoreManager: RecipesStore
  @State private var searchQuery = ""
  @State private var resetSearchPressed = false
  @State private var searchState = SearchState.enterASearch
  private var isAlertPresented: Binding<Bool> {
    Binding(
      get: { self.recipeStoreManager.alertInfo.isAlertPresented },
      set: { self.recipeStoreManager.alertInfo.isAlertPresented = $0 }
    )
  }

  var body: some View {
    NavigationStack {
      ZStack {
        VStack {
          SearchBarView(
            searchQuery: $searchQuery,
            resetSearchPressed: $resetSearchPressed)
          .onSubmit {
            resetSearch()
            searchState = .searching
            print("onSubmit \(searchQuery)")
            recipeStoreManager.searchRecipes(for: searchQuery)
          }
          .onChange(of: resetSearchPressed) { _, _ in
            if resetSearchPressed {
              resetSearch()
            }
          }
          .onChange(of: recipeStoreManager.tastyRecipes.count) { _, newValue in
            if !searchQuery.isEmpty && newValue == 0 {
              searchState = .noResultsFound
            } else if !searchQuery.isEmpty && newValue > 0 {
              searchState = .foundResults
            }
          }
          Spacer()
          if searchState == .searching || searchState == .enterASearch || searchState == .noResultsFound {
            SearchStateView(searchState: $searchState)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else {
            VStack {
              RecipeGridView(
                searchState: $searchState,
                searchQuery: searchQuery,
                recipeType: RecipeType.tastyRecipe)
              .frame(maxWidth: .infinity)
              if searchState == .additionalSearch {
                ProgressView()
              }
            }
          }
        }
        .padding(.top, 20)
      }
      .navigationTitle("Explore")
      .toolbar {
        KeyboardToolbarItem()
      }
      .alert(recipeStoreManager.alertInfo.alertMessage, isPresented: isAlertPresented) {
        Button(action: {
          recipeStoreManager.alertInfo.isAlertPresented = false
          searchState = .noResultsFound
        }, label: {
          Text("OK")
        })
      }
    }
  }

  func resetSearch() {
    recipeStoreManager.resetSearch()
    resetSearchPressed = false
    searchState = .enterASearch
  }
}

#Preview {
  ExploreRecipesView()
    .environmentObject(RecipesStore())
}
