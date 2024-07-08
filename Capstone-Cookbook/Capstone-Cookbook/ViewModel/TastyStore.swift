//
//  TastyStore.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

class TastyStore: ObservableObject {
  @Published var tastyRecipes: [TastyRecipe] = []
  @Published var myRecipesStore = MyRecipeStore()
  @Published var alertInfo = AlertInfo(isAlertPresented: false, alertMessage: "")
  //  @Published var errorText: String?
  var recipeCount = -1
  let networkService = TastyNetworkService()
  var tastyPage = TastyPage()
  func setError(errorText: String) {
    Task {
      await MainActor.run {
        alertInfo = AlertInfo(isAlertPresented: true, alertMessage: errorText)
        print(errorText)
      }
    }
  }
  func searchRecipes(for searchQuery: String) {
    Task {
      do {
        try await fetchRecipesFromTasty(searchQuery: searchQuery)
      } catch NetworkError.invalidURL {
        setError(errorText: "Invalid URL")
      } catch NetworkError.invalidResponse {
        setError(errorText: "Invalid Response")
      } catch NetworkError.invalidData {
        setError(errorText: "Invalid Data")
      } catch NetworkError.apiPlanExceeded {
        setError(errorText: "Oh no!\nPlease call the developer")
      } catch {
        Task {
          await MainActor.run {
            print(error)
          }
        }
        setError(errorText: error.localizedDescription)
      }
    }
  }

  private func fetchRecipesFromTasty(searchQuery: String) async throws {
    let tasty = try await networkService.getListOfRecipes(
      from: tastyPage.from,
      size: tastyPage.size,
      searchQuery: searchQuery)
    let recipes = filterResults(tastyRecipes: tasty.recipes)
    await MainActor.run {
      //          print(tasty.recipes)
      //          print("tasty.count \(tasty.count)")
      self.tastyRecipes.append(contentsOf: recipes)
      self.recipeCount = recipes.count
    }

    // images
    for recipe in tastyRecipes {
      if let recipeIndex = tastyRecipes.firstIndex(where: { $0.id == recipe.id }) {
        let imageDataURL = try await networkService.getImageDataURL(for: recipe)
        if imageDataURL != nil {
          await MainActor.run {
            tastyRecipes[recipeIndex].imageDataURL = imageDataURL
          }
        }
      }
    }
  }

  func scaleRecipe(for recipeID: Int, numberOfPeople: Int) {
    if let index = tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      tastyRecipes[index].numberOfPeople = numberOfPeople
      if let nutrition = tastyRecipes[index].nutrition {
        if let calories = nutrition.calories {
          let cal = ((calories) * numberOfPeople) / tastyRecipes[index].numServing
          print("OLD: \(tastyRecipes[index].numServing) | \(calories)")
          print("NEW: \(numberOfPeople) | \(cal)")
        }
      }
    }
  }

  func resetSearch() {
    tastyRecipes = []
    recipeCount = -1
  }

  func next(for searchQuery: String) {
    tastyPage.nextPage()
    searchRecipes(for: searchQuery)
  }

  private func filterResults(tastyRecipes: [TastyRecipe]) -> [TastyRecipe] {
    let filterTerms = [
      "cocktails", "contains_alcohol", "rum", "whiskey", "tequila", "gin", "vodka", "wine",
      "pork", "ham", "bacon"
    ]
    if filterTerms.isEmpty {
      return tastyRecipes
    }
    let recipes: [TastyRecipe] = tastyRecipes.compactMap { recipe in
      let recipeTags = recipe.tags.map { $0.name.lowercased() }
      if !recipeTags.contains(where: { filterTerms.contains($0.lowercased()) }) {
        if filterTerms.filter({ recipe.name.lowercased().contains($0.lowercased()) }).isEmpty {
          return recipe
        } else {
          return nil
        }
      } else {
        return nil
      }
    }
    return recipes
  }
}
