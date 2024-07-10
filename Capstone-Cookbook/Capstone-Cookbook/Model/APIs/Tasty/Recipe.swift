//
//  Recipe.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 10/07/2024.
//

import Foundation

enum RecipeType: Codable {
  case tastyRecipe
  case customRecipe
}

struct Recipe: Identifiable, Codable, Equatable {
  static func == (lhs: Recipe, rhs: Recipe) -> Bool {
    lhs.id == rhs.id
  }

  var id: Int
  var tastyRecipe: TastyRecipe
  let recipeType: RecipeType
  var isRecipeAddedToMyCookbook = false
}
