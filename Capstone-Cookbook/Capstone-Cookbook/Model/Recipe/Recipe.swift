//
//  Recipe.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 07/07/2024.
//

import Foundation

enum RecipeType {
  case tastyRecipe
  case customRecipe
}

struct Recipe: Identifiable {
  let recipeType: RecipeType
  let addedAt: Date
  let id: Int
  let name: String
  let description: String
  let prepTimeMinutes: Int?
  let cookTimeMinutes: Int?
  let totalTimeMinutes: Int?
  let instructions: [Instructions]
  var ingredientSections: [IngredientSections]
  let keywords: [String]?
  var numServing: Int
  let thumbnailURL: String
  let videoURL: String?
  let nutrition: Nutrition?
  let tags: [Tag]?
  init(tastyRecipe: TastyRecipe) {
    self.recipeType = .tastyRecipe
    self.addedAt = Date()
    self.id = tastyRecipe.id
    self.name = tastyRecipe.name
    self.description = tastyRecipe.description
    self.prepTimeMinutes = tastyRecipe.prepTimeMinutes
    self.cookTimeMinutes = tastyRecipe.cookTimeMinutes
    self.totalTimeMinutes = tastyRecipe.totalTimeMinutes
    self.instructions = tastyRecipe.instructions
    self.numServing = tastyRecipe.numServing
    self.thumbnailURL = tastyRecipe.beautyURL ?? tastyRecipe.thumbnailURL
    self.videoURL = tastyRecipe.videoURL ?? tastyRecipe.originalVideoURL
    self.ingredientSections = tastyRecipe.ingredientSections
    self.keywords = []
    self.nutrition = nil
    self.tags = []
    //    self.ingredient = createSomething()
  }

  //  func createSomething() -> Ingredient {
  //
  //  }
}


// let id: Int
// let name: String
// let description: String
// let prepTimeMinutes: Int?
// let cookTimeMinutes: Int?
// let totalTimeMinutes: Int?
// let instructions: [Instructions]
// let sections: [Section]
// let keywords: String?
// // family dinner, jonah peretti, secret ingredient pasta, tast
// var numServing: Int
// var numberOfPeople: Int? // custom
// let thumbnailURL: String // https://img.buzzfeed.com/thumbnail
// let beautyURL: String? // https://img.buzzfeed.com/video-api-p
// let originalVideoURL: String? // https://s3.amazonaws.com/vide
// let videoURL: String? // https://vid.tasty.co/output/57946/low
// var nutrition: Nutrition?
// let language: String // eng
// let tags: [Tag]
