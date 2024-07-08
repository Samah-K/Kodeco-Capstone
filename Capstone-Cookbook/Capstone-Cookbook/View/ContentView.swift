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
}

struct ContentView: View {
  var body: some View {
    TabView {
      ExploreRecipesView()
        .tabItem {
          Text("Explore")
          Image(systemName: "magnifyingglass")
        }

      MyRecipeView()
        .tabItem {
          Text("CookBook")
          Image(systemName: "book.fill")
        }
    }
  }
}

struct MyRecipeView: View {
  @EnvironmentObject var tastyStore: TastyStore
  var body: some View {
    NavigationStack {
      List(tastyStore.myRecipesStore.myRecipes) { recipe in
        NavigationLink {
          RecipeDetailsView(recipe: recipe)
        } label: {
          Text(recipe.name)
        }
      }
      .navigationTitle("My Recipes")
    }
  }
}

struct ExploreRecipesView: View {
  @EnvironmentObject var tastyStore: TastyStore
  @State var searchQuery = ""
  @State var resetSearchPressed = false
  @State var searchState = SearchState.enterASearch
  private var isAlertPresented: Binding<Bool> {
    Binding(
      get: { self.tastyStore.alertInfo.isAlertPresented },
      set: { self.tastyStore.alertInfo.isAlertPresented = $0 }
    )
  }

  var body: some View {
    NavigationStack {
      VStack {
        SearchBarView(
          searchQuery: $searchQuery,
          resetSearchPressed: $resetSearchPressed
        ).onSubmit {
          resetSearch()
          searchState = .searching
          print("onSubmit \(searchQuery)")
          tastyStore.searchRecipes(for: searchQuery)
        }
        .onChange(of: resetSearchPressed) { _, _ in
          if resetSearchPressed {
            resetSearch()
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
          VStack {
            RecipeGridView(searchState: $searchState, recipes: tastyStore.tastyRecipes, searchQuery: searchQuery)
              .frame(maxWidth: .infinity)
            //            List(tastyStore.tastyRecipes) { recipe in
            //              //            Text(recipe.name)
            //              NavigationLink {
            //                RecipeDetailsView(
            //                  recipe: recipe)
            //              } label: {
            //                //                Text(recipe.name)
            //                RecipeItemView(recipe: recipe)
            //                  .onAppear {
            //                    // TODO: ADD A PROGRESS VIEW
            //                    if let last = self.tastyStore.tastyRecipes.last {
            //                      if last.id == recipe.id {
            //                        print("NEXT")
            //                        self.tastyStore.next(for: searchQuery)
            //                        self.searchState = .additionalSearch
            //                      }
            //                    }
            //                  }
            //              }
            //            }
            if searchState == .additionalSearch {
              ProgressView()
            }
          }
        }
      }
      .padding()
      .navigationTitle("Explore")
      .alert(tastyStore.alertInfo.alertMessage, isPresented: isAlertPresented) {
        Button(action: {
          tastyStore.alertInfo.isAlertPresented = false
          searchState = .noResultsFound
        }, label: {
          Text("OK")
        })
      }
    }
  }

  func resetSearch() {
    tastyStore.resetSearch()
    resetSearchPressed = false
    searchState = .enterASearch
  }
}

struct RecipeGridView: View {
  @EnvironmentObject var tastyStore: TastyStore
  @Binding var searchState: SearchState
  let recipes: [TastyRecipe]
  let searchQuery: String

  var body: some View {
    ScrollView {
      let columns = [GridItem(.adaptive(minimum: 160, maximum: 180))]
      LazyVGrid(columns: columns, spacing: 4) {
        ForEach(recipes) { recipe in
          NavigationLink {
            RecipeDetailsView(
              recipe: recipe)
          } label: {
            RecipeItemView(recipe: recipe)
              .onAppear {
                if let last = self.tastyStore.tastyRecipes.last {
                  if last.id == recipe.id {
                    print("NEXT")
                    self.tastyStore.next(for: searchQuery)
                    self.searchState = .additionalSearch
                  }
                }
              }
          }
        }
      }
    }
  }
}


#Preview {
  ContentView()
    .environmentObject(TastyStore())
}

#Preview("RecipeGridView") {
  RecipeGridView(searchState: .constant(.searching), recipes: TastyStore().tastyRecipes, searchQuery: "pie")
    .environmentObject(TastyStore())
}
