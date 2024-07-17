//
//  Recipe.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 10/07/2024.
//

import Foundation

enum RecipeType: Codable {
  case tastyRecipe
  case myRecipe
}

struct Recipe: Identifiable, Codable {
  var id: String
  var tastyRecipe: TastyRecipe
  var recipeType: RecipeType
  var isRecipeAddedToMyCookbook = false

  init(tastyRecipe: TastyRecipe?, recipeType: RecipeType, isRecipeAddedToMyCookbook: Bool = false) {
    self.recipeType = recipeType
    self.isRecipeAddedToMyCookbook = isRecipeAddedToMyCookbook
    if let tastyRecipe = tastyRecipe {
      self.id = "\(tastyRecipe.id)"
      self.tastyRecipe = tastyRecipe
    } else {
      self.id = UUID().uuidString
      self.tastyRecipe = TastyRecipe(
        id: id.hashValue,
        name: "",
        description: "",
        prepTimeMinutes: nil,
        cookTimeMinutes: nil,
        totalTimeMinutes: nil,
        instructions: [],
        ingredientSections: [],
        keywords: nil,
        numServing: 0,
        thumbnailURL: "",
        beautyURL: nil,
        originalVideoURL: nil,
        videoURL: "",
        language: "eng",
        tags: [])
    }
  }
}
