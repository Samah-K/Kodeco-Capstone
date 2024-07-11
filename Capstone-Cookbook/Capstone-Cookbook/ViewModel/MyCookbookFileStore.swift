//
//  MyRecipeStore.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 06/07/2024.
//

import Foundation

class MyCookbookFileStore {
  private let fileName = "MyRecipes"

  func writeRecipeToFile(myRecipes: [Recipe]) {
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

  func readRecipesFromJSONFile() -> [Recipe] {
    do {
      let myRecipeURL = URL(
        filePath: fileName,
        relativeTo: FileManager.documentDirectoryURL
      ).appendingPathExtension("JSON")
      print(myRecipeURL)
      if FileManager.default.fileExists(atPath: myRecipeURL.path) {
        let myRecipesData = try Data(contentsOf: myRecipeURL)
        return try JSONDecoder().decode([Recipe].self, from: myRecipesData)
      }
    } catch {
      print(error)
    }
    return []
  }
}
