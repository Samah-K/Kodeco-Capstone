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

  init(id: String = UUID().uuidString, tastyRecipe: TastyRecipe?, recipeType: RecipeType, isRecipeAddedToMyCookbook: Bool = false) {
    self.id = id
    self.recipeType = recipeType
    self.isRecipeAddedToMyCookbook = isRecipeAddedToMyCookbook
    if let tastyRecipe = tastyRecipe {
      self.tastyRecipe = tastyRecipe
    } else {
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
