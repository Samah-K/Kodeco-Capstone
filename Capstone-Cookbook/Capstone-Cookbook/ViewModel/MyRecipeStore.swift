//
//  MyRecipeStore.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 06/07/2024.
//

import Foundation

public extension FileManager {
  static var documentDirectoryURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}

class MyRecipeStore {
  private let fileName = "MyRecipes"
  var myRecipes: [Recipe] = [] // read from file and write to file

  init() {
    readRecipesFromJSONFile()
  }

  func addNewRecipe(recipe: Recipe) {
    myRecipes.append(recipe)
    if let index = myRecipes.firstIndex(where: { recipe.id == $0.id }) {
      myRecipes[index].isRecipeAddedToMyCookbook = true
    }
    writeRecipeToFile()
  }
  func removeRecipe(recipeID: Int) {
    if let index = myRecipes.firstIndex(where: { recipeID == $0.id }) {
      myRecipes[index].isRecipeAddedToMyCookbook = false
      myRecipes.remove(at: index)
      writeRecipeToFile()
    }
  }

  func writeRecipeToFile() {
    let encoding = JSONEncoder()
    encoding.outputFormatting = .prettyPrinted
    do {
      let myRecipesData = try encoding.encode(myRecipes)
      let myRecipeURL = URL(
        filePath: fileName,
        relativeTo: FileManager.documentDirectoryURL
      ).appendingPathExtension("JSON")
      print(myRecipeURL)
      try myRecipesData.write(to: myRecipeURL, options: .atomic)
    } catch {
      print(error)
    }
  }

  func readRecipesFromJSONFile() {
    do {
      let myRecipeURL = URL(
        filePath: fileName,
        relativeTo: FileManager.documentDirectoryURL
      ).appendingPathExtension("JSON")
      print(myRecipeURL)
      if FileManager.default.fileExists(atPath: myRecipeURL.path) {
        let myRecipesData = try Data(contentsOf: myRecipeURL)
        myRecipes = try JSONDecoder().decode([Recipe].self, from: myRecipesData)
      }
    } catch {
      print(error)
    }
  }

  func checkIfRecipeIsAddedToMyCookbook(tastyRecipeID: Int) -> Bool {
    if myRecipes.first(where: { tastyRecipeID == $0.id }) != nil {
      return true
    }
    return false
  }
}
