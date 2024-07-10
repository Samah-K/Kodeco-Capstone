//
//  TastyStore.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

class RecipeStoresManager: ObservableObject {
  @Published var myRecipesStore = MyRecipeStore()
  @Published var tastyStore = TastyStore()
//  @Published var count: Int = -1
  let networkService = TastyNetworkService()

//  @Published var tastyRecipes: [Recipe] = []
//  let networkService = TastyNetworkService()
//  var tastyPage = TastyPage()
  @Published var alertInfo = AlertInfo(isAlertPresented: false, alertMessage: "")


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
    var tasty: Tasty
    if TastyJSONSample().isPreview {
      guard let tastyFromJSONFile = TastyJSONSample().getRecipeFromJSONFile() else {
        throw FileErrors.previewJSONFileNotExists
      }
      tasty = tastyFromJSONFile
    } else {
      tasty = try await networkService.getListOfRecipes(
        from: tastyStore.tastyPage.from,
        size: tastyStore.tastyPage.size,
        searchQuery: searchQuery)
    }
    let filteredRecipes = filterResults(tastyRecipes: tasty.recipes)
    await MainActor.run {
      //          print(tasty.recipes)
      //          print("tasty.count \(tasty.count)")
      let recipes = filteredRecipes.map { recipe in
        Recipe(
          id: recipe.id,
          tastyRecipe: recipe,
          recipeType: .tastyRecipe,
          isRecipeAddedToMyCookbook: false)
      }
      //      for recipe in recipes {
      //        let tastyRecipe = Recipe(
      //          id: recipe.id,
      //          tastyRecipe: recipe,
      //          recipeType: .tastyRecipe,
      //          isRecipeAddedToMyCookbook: false
      //        )
      self.tastyStore.tastyRecipes.append(contentsOf: recipes)
      objectWillChange.send()
      //            self.count = self.tastyStore.tastyRecipes.count
      //        objectch
      //      }
      //            self.tastyRecipes.append(contentsOf: recipes)
      //      self.recipeCount = recipes.count
      //      print(recipeCount)
      //            objectWillChange.send()
      //            checkIfTastyRecipeIsAddedToMyCookBook()
    }

    // images
    for recipe in tastyStore.tastyRecipes {
      if let recipeIndex = tastyStore.tastyRecipes.firstIndex(where: { $0.id == recipe.id }) {
        let imageDataURL = try await networkService.getImageDataURL(for: recipe.tastyRecipe)
        if imageDataURL != nil {
          await MainActor.run {
            tastyStore.tastyRecipes[recipeIndex].tastyRecipe.imageDataURL = imageDataURL
            objectWillChange.send()
          }
        }
      }
    }
  }

  //  private func checkIfTastyRecipeIsAddedToMyCookBook(recipeID: Int) -> Bool{
  //    if let index = tastyRecipes.firstIndex(where: { recipeID == $0.id }) {
  //
  //    }
  //  }

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
    //    self.tastyStore.tastyRecipes.resetSearch()
    tastyStore.tastyRecipes = []
    //    recipeCount = -1
  }

  func nextSearch(for searchQuery: String) {
    if !TastyJSONSample().isPreview {
      tastyStore.tastyPage.nextPage()
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

//  func resetSearch() {
//    tastyStore.resetSearch()
//  }
//
//  func next(for searchQuery: String) {
//    tastyStore.next(for: searchQuery)
//  }

//  func isRecipeAddedToMyCookbook(tastyRecipeID: Int) -> Bool {
//    if let index = tastyRecipes.firstIndex(where: { $0.id == tastyRecipeID }) {
//      
//    }
//  }

  func addRecipeToMyCookBook(recipeID: Int) -> Bool {
    if let index = tastyStore.tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      tastyStore.tastyRecipes[index].isRecipeAddedToMyCookbook = true
      myRecipesStore.addNewRecipe(recipe: tastyStore.tastyRecipes[index])
      //      checkTastyArray()
      return true
    }
    return false
  }

  func removeRecipeFromMyCookBook(recipeID: Int) {
    if let index = tastyStore.tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      tastyStore.tastyRecipes[index].isRecipeAddedToMyCookbook = false
      myRecipesStore.removeRecipe(recipeID: recipeID)
      //      checkTastyArray()
    }
  }

//  func checkTastyArray() {
//    for tastyRecipe in tastyStore.tastyRecipes {
//      print("\(tastyRecipe.name) - \(tastyRecipe.isRecipeAddedToMyCookbook ?? false)")
//    }
//  }

  func getTastyRecipeIndex(from recipeID: Int) -> Int? {
    if let index = tastyStore.tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      return index
    }
    return nil
  }

//  private func filterResults(tastyRecipes: [TastyRecipe]) -> [TastyRecipe] {
//    let filterTerms = [
//      "cocktails", "contains_alcohol", "rum", "whiskey", "tequila", "gin", "vodka", "wine",
//      "pork", "ham", "bacon"
//    ]
//    if filterTerms.isEmpty {
//      return tastyRecipes
//    }
//    let recipes: [TastyRecipe] = tastyRecipes.compactMap { recipe in
//      let recipeTags = recipe.tags.map { $0.name.lowercased() }
//      if !recipeTags.contains(where: { filterTerms.contains($0.lowercased()) }) {
//        if filterTerms.filter({ recipe.name.lowercased().contains($0.lowercased()) }).isEmpty {
//          return recipe
//        } else {
//          return nil
//        }
//      } else {
//        return nil
//      }
//    }
//    return recipes
//  }
}
