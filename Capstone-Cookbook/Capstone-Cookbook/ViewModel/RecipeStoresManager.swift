//
//  TastyStore.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

class RecipeStoresManager: ObservableObject {
  @Published var alertInfo = AlertInfo(isAlertPresented: false, alertMessage: "")
  @Published var tastyRecipes: [Recipe] = []
  @Published var myRecipes: [Recipe] = [] // read from file and write to file

  var tastyPage = TastyPage()
  let networkService = TastyNetworkService()
  var searchCanceled = false
  let myRecipeFileStore = MyCookbookFileStore()

  func setError(errorText: String) {
    Task {
      await MainActor.run {
        alertInfo = AlertInfo(isAlertPresented: true, alertMessage: errorText)
        print(errorText)
      }
    }
  }

  init() {
    myRecipes = myRecipeFileStore.readRecipesFromJSONFile()
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
    searchCanceled = false
    var tasty: Tasty
    if TastyJSONSample().isPreview {
      guard let tastyFromJSONFile = TastyJSONSample().getRecipeFromJSONFile() else {
        throw FileErrors.previewJSONFileNotExists
      }
      tasty = tastyFromJSONFile
    } else {
      tasty = try await networkService.getListOfRecipes(
        from: tastyPage.from,
        size: tastyPage.size,
        searchQuery: searchQuery)
    }
    let filteredRecipes = filterResults(tastyRecipes: tasty.recipes)
    await MainActor.run {
      let recipes = filteredRecipes.map { recipe in
        Recipe(
          id: recipe.id,
          tastyRecipe: recipe,
          recipeType: .tastyRecipe,
          isRecipeAddedToMyCookbook: isRecipeAddedToMyCookbook(tastyRecipeID: recipe.id))
      }
      self.tastyRecipes.append(contentsOf: recipes)
    }

    // images
    for recipe in tastyRecipes {
      if let recipeIndex = tastyRecipes.firstIndex(where: { $0.id == recipe.id }) {
        let imageDataURL = try await networkService.getImageDataURL(for: recipe.tastyRecipe)
        if imageDataURL != nil {
          await MainActor.run {
            if !searchCanceled {
              tastyRecipes[recipeIndex].tastyRecipe.imageDataURL = imageDataURL
            }
          }
        }
      }
    }
  }

  //  func scaleRecipe(for recipeID: Int, numberOfPeople: Int) {
  //    if let index = tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
  //      tastyRecipes[index].numberOfPeople = numberOfPeople
  //      if let nutrition = tastyRecipes[index].nutrition {
  //        if let calories = nutrition.calories {
  //          let cal = ((calories) * numberOfPeople) / tastyRecipes[index].numServing
  //          print("OLD: \(tastyRecipes[index].numServing) | \(calories)")
  //          print("NEW: \(numberOfPeople) | \(cal)")
  //        }
  //      }
  //    }
  //  }

  func resetSearch() {
    tastyRecipes = []
    searchCanceled = true
  }

  func nextSearch(for searchQuery: String) {
    if !TastyJSONSample().isPreview {
      tastyPage.nextPage()
      searchRecipes(for: searchQuery)
    }
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

  func isRecipeAddedToMyCookbook(tastyRecipeID: Int) -> Bool {
    if myRecipes.firstIndex(where: { $0.id == tastyRecipeID }) != nil {
      return true
    }
    return false
  }

  func addRecipeToMyCookBook(recipeID: Int) -> Bool {
    if let index = tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      tastyRecipes[index].isRecipeAddedToMyCookbook = true
      addNewRecipeToCookBook(recipe: tastyRecipes[index])
      return true
    }
    return false
  }

  func removeRecipeFromMyCookBook(recipeID: Int) {
    if let index = tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      tastyRecipes[index].isRecipeAddedToMyCookbook = false
      removeRecipe(recipeID: recipeID)
    }
  }

  private func addNewRecipeToCookBook(recipe: Recipe) {
    myRecipes.append(recipe)
    if let index = myRecipes.firstIndex(where: { recipe.id == $0.id }) {
      myRecipes[index].isRecipeAddedToMyCookbook = true
    }
    myRecipeFileStore.writeRecipeToFile(myRecipes: myRecipes)
  }
  private func removeRecipe(recipeID: Int) {
    if let index = myRecipes.firstIndex(where: { recipeID == $0.id }) {
      myRecipes[index].isRecipeAddedToMyCookbook = false
      myRecipes.remove(at: index)
      myRecipeFileStore.writeRecipeToFile(myRecipes: myRecipes)
    }
  }

  func getTastyRecipeIndex(from recipeID: Int) -> Int? {
    if let index = tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      return index
    }
    return nil
  }
}
