//
//  ContentView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import SwiftUI

enum SearchState {
  case enterASearch   // no search was entered yet
  case noResultsFound // no results were found after user entered a search
  case foundResults // found results and display them on screen
  case searching // The app is searching
}

struct ContentView: View {
  @StateObject var tastyStore = TastyStore()
  @State var searchQuery = ""
  @State var resetSearchPressed = false
  @State var searchState = SearchState.enterASearch
  var body: some View {
    NavigationStack {
      VStack {
        SearchBarView(
          searchQuery: $searchQuery,
          resetSearchPressed: $resetSearchPressed
        ).onSubmit {
          searchState = .searching
          print("onSubmit \(searchQuery)")
          tastyStore.searchRecipes(for: searchQuery)
        }
        .onChange(of: resetSearchPressed) { _, _ in
          if resetSearchPressed {
            tastyStore.resetSearch()
            resetSearchPressed = false
            searchState = .enterASearch
          }
        }
        .onChange(of: tastyStore.recipeCount) { _, newValue in
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
          List(tastyStore.tastyRecipes) { recipe in
            //            Text(recipe.name)
            NavigationLink {
              RecipeDetailsView(recipe: recipe)
            } label: {
              Text(recipe.name)
            }
          }
        }
      }
      .padding()
      .navigationTitle("My Recipe App")
    }
  }
}

#Preview {
  ContentView()
}
