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


class MyRecipeStore: ObservableObject {
  private let fileName = "MyRecipes"
  @Published var myRecipes: [TastyRecipe] = [] // read from file and write to file

  init() {
    readRecipesFromJSONFile()
  }

  func addNewRecipe(recipe: TastyRecipe) {
    myRecipes.append(recipe)
    writeRecipeToFile()
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
    let decoder = JSONDecoder()
    do {
      let myRecipeURL = URL(
        filePath: fileName,
        relativeTo: FileManager.documentDirectoryURL
      ).appendingPathExtension("JSON")
      let myRecipesData = try Data(contentsOf: myRecipeURL)
      myRecipes = try decoder.decode([TastyRecipe].self, from: myRecipesData)
    } catch {
      print(error)
    }
  }
}
