//
//  TastyStore.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

class RecipesStore: ObservableObject {
  @Published var alertInfo = AlertInfo(isAlertPresented: false, alertMessage: "")
  @Published var tastyRecipes: [Recipe] = []
  @Published var myRecipes: [Recipe] = [] // read from file and write to file

  var tastyPage = TastyPage()
  let tastyNetworkService = TastyNetworkService()
  let spoonacularNetworkService = SpoonacularNetworkService()
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

  init(fetchFromFile: Bool = true) {
    if fetchFromFile {
      myRecipes = myRecipeFileStore.readRecipesFromJSONFile()
    }
  }

  func searchRecipes(for searchQuery: String) {
    Task {
      do {
        try await fetchRecipesFromTasty(searchQuery: searchQuery)
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

  func fetchRecipesFromTasty(searchQuery: String) async throws {
    searchCanceled = false
    var tasty: Tasty
    guard !searchQuery.isEmpty
    else {
      throw NetworkError.invalidSearchQuery
    }
    if TastyJSONSample().isPreview {
      guard let tastyFromJSONFile = TastyJSONSample().getRecipeFromJSONFile() else {
        throw FileErrors.previewJSONFileNotExists
      }
      tasty = tastyFromJSONFile
    } else {
      tasty = try await tastyNetworkService.getListOfRecipes(
        from: tastyPage.from,
        size: tastyPage.size,
        searchQuery: searchQuery)
    }
    let filteredRecipes = filterResults(tastyRecipes: tasty.recipes)
    await MainActor.run {
      let recipes = filteredRecipes.map { recipe in
        Recipe(
          tastyRecipe: recipe,
          recipeType: .tastyRecipe,
          isRecipeAddedToMyCookbook: isRecipeAddedToMyCookbook(tastyRecipeID: "\(recipe.id)"))
      }
      self.tastyRecipes.append(contentsOf: recipes)
    }

    // images
    for recipe in tastyRecipes {
      if let recipeIndex = tastyRecipes.firstIndex(where: { $0.id == recipe.id }) {
        let imageDataURL = try await tastyNetworkService.getImageDataURL(for: recipe.tastyRecipe)
        if imageDataURL != nil {
          await MainActor.run {
            if !searchCanceled && !tastyRecipes.isEmpty {
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

  func isRecipeAddedToMyCookbook(tastyRecipeID: String) -> Bool {
    if myRecipes.firstIndex(where: { $0.id == tastyRecipeID }) != nil {
      return true
    }
    return false
  }

  func addRecipeToMyCookBook(recipeID: String) -> Bool {
    if let index = tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      tastyRecipes[index].isRecipeAddedToMyCookbook = true
      addNewRecipeToCookBook(recipe: tastyRecipes[index])
      return true
    }
    return false
  }

  func removeRecipeFromMyCookBook(recipeID: String) {
    if let index = tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      tastyRecipes[index].isRecipeAddedToMyCookbook = false
    }
    removeRecipe(recipeID: recipeID)
  }

  func addNewRecipeToCookBook(recipe: Recipe) {
    myRecipes.append(recipe)
    if let index = myRecipes.firstIndex(where: { recipe.id == $0.id }) {
      myRecipes[index].recipeType = .myRecipe
      myRecipes[index].isRecipeAddedToMyCookbook = true
    }
    myRecipeFileStore.writeRecipeToFile(myRecipes: myRecipes)
  }
  private func removeRecipe(recipeID: String) {
    if let index = myRecipes.firstIndex(where: { recipeID == $0.id }) {
      myRecipes[index].isRecipeAddedToMyCookbook = false
      myRecipes.remove(at: index)
      myRecipeFileStore.writeRecipeToFile(myRecipes: myRecipes)
    }
  }

  func getTastyRecipeIndex(from recipeID: String) -> Int? {
    if let index = tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
      return index
    }
    return nil
  }

  func saveChangesOnRecipe(_ recipe: Recipe) {
    if let index = myRecipes.firstIndex(where: { $0.id == recipe.id }) {
      myRecipes[index] = recipe
    } else {
      myRecipes.append(recipe)
    }
    myRecipeFileStore.writeRecipeToFile(myRecipes: myRecipes)
  }

  func saveImage(imageName: String, data: Data) throws -> String {
    do {
      let fileName = FileManager.documentDirectoryURL.appending(component: imageName)
      if FileManager.default.fileExists(atPath: fileName.path()) {
        try FileManager.default.removeItem(at: fileName)
      }
      try data.write(to: fileName)
      return fileName.path()
    } catch {
      print(error.localizedDescription)
      alertInfo = AlertInfo(isAlertPresented: true, alertMessage: "Can't load image")
      throw FileErrors.previewJSONFileNotExists
    }
  }

  func loadImage(imageName: String) -> String? {
//    do {
    let fileName = FileManager.documentDirectoryURL.appending(component: "Image-\(imageName)").appendingPathExtension("jpg")
      if FileManager.default.fileExists(atPath: fileName.path()) {
        return fileName.path()
      }
    return nil
//    }
  }

  func convertAmount(of ingredientName: String, from amount: Double, _ fromUnit: UnitsName, to toUnit: UnitsName, delegate: CalculateAmountProtocol) {
    Task {
      do {
        let unitAmount = try await spoonacularNetworkService.covertingAmounts(
          ingredient: ingredientName,
          sourceUnit: fromUnit.rawValue,
          sourceAmount: amount,
          targetUnit: toUnit.rawValue)
        if let toSystem = toUnit.getUnitSystem() {
          delegate.updateUI(to: unitAmount, toSystem)
        } else {
          delegate.noResultWasFound()
        }
      } catch {
        delegate.noResultWasFound()
        print(error)
      }
    }
  }
}
