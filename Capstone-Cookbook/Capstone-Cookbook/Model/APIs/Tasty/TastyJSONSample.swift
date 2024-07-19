//
//  TastyJSON.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

struct TastyJSONSample {
  func getRecipeFromJSONFile() -> Tasty? {
    guard let jsonFile = Bundle.main.url(forResource: "RecipesSample", withExtension: "json")
    else {
      print("No file`Recipe.json`")
      return nil
    }
    do {
      let recipeData = try Data(contentsOf: jsonFile)
      let recipe = try JSONDecoder().decode(Tasty.self, from: recipeData)
      return recipe
    } catch {
      print(error)
      return nil
    }
  }

  var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
  }
//  var isPreview: Bool {
//    return true
//  }
}
