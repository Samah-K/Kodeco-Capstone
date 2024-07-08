//
//  TastyJSON.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

struct TastyJSON {
  func getRecipeFromJSONFile() -> TastyRecipe? {
    guard let jsonFile = Bundle.main.url(forResource: "Recipe", withExtension: "json")
    else {
      print("No file`Recipe.json`")
      return nil
    }
    do {
      let recipeData = try Data(contentsOf: jsonFile)
      let recipe = try JSONDecoder().decode(TastyRecipe.self, from: recipeData)
      return recipe
    } catch {
      print(error)
      return nil
    }
  }
}
