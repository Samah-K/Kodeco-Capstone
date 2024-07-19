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
  case additionalSearch
  case none // For "CookBook"'s grid (don't show SearchState view)
}

struct ContentView: View {
  @State private var tabSelection = 1
  var body: some View {
    TabView(selection: $tabSelection) {
      MyRecipesView(tabSelection: $tabSelection)
        .tabItem {
          Text("CookBook")
          Image(systemName: "book.fill")
        }
        .tag(1)

      ExploreRecipesView()
        .tabItem {
          Text("Explore")
          Image(systemName: "magnifyingglass")
        }
        .tag(2)
    }
  }
}

#Preview {
  ContentView()
    .environmentObject(RecipesStore())
}
