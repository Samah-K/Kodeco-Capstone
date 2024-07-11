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
  var body: some View {
    TabView {
      ExploreRecipesView()
        .tabItem {
          Text("Explore")
          Image(systemName: "magnifyingglass")
        }

      MyRecipesView()
        .tabItem {
          Text("CookBook")
          Image(systemName: "book.fill")
        }
    }
  }
}

#Preview {
  ContentView()
    .environmentObject(RecipesStore())
}
