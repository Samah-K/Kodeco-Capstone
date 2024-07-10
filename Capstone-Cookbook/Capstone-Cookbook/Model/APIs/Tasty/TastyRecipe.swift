//
//  TastyRecipe.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

// Model for search result, and getting more info and listOfsimilarRecipes
struct Tasty: Codable {
  let count: Int
  let recipes: [TastyRecipe]
  enum CodingKeys: String, CodingKey {
    case count
    case recipes = "results"
  }
}

struct TastyRecipe: Codable, Identifiable {
  let id: Int
  let name: String
  let description: String
  let prepTimeMinutes: Int?
  let cookTimeMinutes: Int?
  let totalTimeMinutes: Int?
  let instructions: [Instructions]
  let ingredientSections: [IngredientSections]
  let keywords: String?
  // family dinner, jonah peretti, secret ingredient pasta, tasty, tasty_contains_alcohol, tomato and anchovy pasta recipe, umami pasta
  var numServing: Int
  var numberOfPeople: Int? // custom
  let thumbnailURL: String // https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/109214.jpg
  let beautyURL: String? // https://img.buzzfeed.com/video-api-prod/assets/cf1fdbad99ef4b278ca7b8c61504b6c2/Beauty2_Thumb.jpg
  let originalVideoURL: String? // https://s3.amazonaws.com/video-api-prod/assets/723faf4d7887464b82e81d2604797f83/BFV30681_ApplePieCheescake_FB1080SQ.mp4
  let videoURL: String? // https://vid.tasty.co/output/57946/low_1508803850.m3u8
  var nutrition: Nutrition?
  let language: String // eng
  let tags: [Tag]
  var imageDataURL: URL?
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case description
    case prepTimeMinutes  = "prep_time_minutes"
    case cookTimeMinutes  = "cook_time_minutes"
    case totalTimeMinutes = "total_time_minutes"
    case instructions
    case ingredientSections = "sections"
    case keywords
    case numServing = "num_servings"
    case originalVideoURL = "original_video_url"
    case videoURL     = "video_url"
    case thumbnailURL = "thumbnail_url"
    case beautyURL = "beauty_url"
    case nutrition = "nutrition"
    case language  = "language"
    case tags
    case imageDataURL
  }
  func getRecipeImageURL() -> String {
    if let beautyURL = self.beautyURL {
      return beautyURL
    } else {
      return self.thumbnailURL
    }
  }
}

struct Nutrition: Codable {
  var calories: Int?
  let carbohydrates: Int?
  let fat: Int?
  let fiber: Int?
  let protein: Int?
  let sugar: Int?
  let updatedAt: String?

  enum CodingKeys: String, CodingKey {
    case calories
    case carbohydrates
    case fat
    case fiber
    case protein
    case sugar
    case updatedAt = "updated_at"
  }
}

struct Instructions: Codable, Identifiable {
  let displayText: String
  let appliance: String?
  let position: Int?
  let id = UUID()
  let startTime: Int?
  let endTime: Int?
  let temperature: Int?
  enum CodingKeys: String, CodingKey {
    case displayText = "display_text"
    case appliance   = "appliance"
    case position
    case startTime = "start_time"
    case endTime = "end_time"
    case temperature
  }
  func getBulletOrNumber() -> String {
    var bullet = "•"
    if let position = position {
      bullet = "Step \(position) -"
    }
    return bullet
  }
}

struct IngredientSections: Codable, Identifiable {
  let id = UUID()
  let components: [Component]
  let name: String?
  let position: Int?
  enum CodingKeys: CodingKey {
    case components, name, position
  }
}

struct Component: Codable, Identifiable {
  var id = UUID()
  let extraComment: String
  let rawText: String
  let position: Int?
  var ingredient: Ingredient
  var measurements: [Measurement]
  enum CodingKeys: String, CodingKey {
    case extraComment = "extra_comment"
    case rawText      = "raw_text"
    case ingredient, measurements, position
  }
  func getIngredientDescription() -> String {
    if rawText != "n/a" {
      return rawText
    } else {
      let ingredientName = ingredient.name
      var ingredientMeasurement = ""
      if measurements.count <= 1 {
        let measurement = measurements[0]
        let quantity = measurement.quantity
        let name = measurement.unit.name
        ingredientMeasurement = (quantity == "0") ? "\(name)" : "\(quantity) \(name) of"
      } else {
        // metric or imperial
        let measurement = measurements[0]
        let quantity = measurement.quantity
        let name = measurement.unit.name
        ingredientMeasurement = "\(quantity) \(name)"
      }
      return "\(ingredientMeasurement) \(ingredientName)"
    }
  }
}

struct Ingredient: Codable {
  let createdAt: Int
  let displayPlural: String?
  let displaySingular: String?
  let id: Int
  let name: String
  let updatedAt: Int
  enum CodingKeys: String, CodingKey {
    case createdAt     = "created_at"
    case updatedAt     = "updated_at"
    case displayPlural = "display_plural"
    case displaySingular = "display_singular"
    case id
    case name
  }
}

struct Measurement: Codable {
  let id: Int
  let quantity: String
  let unit: Unit
}

struct Unit: Codable {
  let abbreviation: String
  let displayPlural: String
  let displaySingular: String
  let name: String
  let system: String
  enum CodingKeys: String, CodingKey {
    case abbreviation
    case displayPlural   = "display_plural"
    case displaySingular = "display_singular"
    case name
    case system
  }
}

struct TastyRecipeModel {
  func getExample() -> Recipe {
    let example = TastyRecipe(
      id: 951,
      name: "Apple Pie From Scratch",
      description: "Homemade apple pie is a timeless, all-time favorite dessert for many." +
      " Crafting an apple pie from scratch is fulfilling in so many ways." +
      " It\'s a process that, once mastered, is satisfying and a dessert that, when eaten, is delightful." +
      " Begin by making a buttery, flaky pie crust with basic pantry staples." +
      " Then, fill the crust with freshly sliced apples tossed in sugar, spices, and a touch of citrus." +
      " As the pie bakes, the crust turns golden brown with a glistening finish thanks to egg wash and" +
      " a sugar sprinkle. Serve up generous slices crowned with a scoop of vanilla ice cream.",
      prepTimeMinutes: 15,
      cookTimeMinutes: 60,
      totalTimeMinutes: 120,
      instructions: [],
      ingredientSections: [],
      keywords: "apple, apple pie, bake, buzzfeed, comfort food, dessert, easy, "
      + "from scratch, fruit, homemade, pie, tasty, tasty_vegetarian",
      numServing: 8,
      thumbnailURL: "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/2b422cd19f6c488fbe649da9739b5542/fb.jpg",
      beautyURL: nil,
      originalVideoURL: "https://s3.amazonaws.com/video-api-prod/assets/3593865599de4bf8a15d528c2b18cc69/fb.mp4",
      videoURL: "https://vid.tasty.co/output/29645/low_1492635519.m3u8",
      nutrition: nil,
      language: "eng",
      tags: [])
    let recipeExample = Recipe(id: example.id, tastyRecipe: example, recipeType: .tastyRecipe)
    guard let tastyFromJSONFile = TastyJSONSample().getRecipeFromJSONFile()
    else {
      return recipeExample
    }
    if let reciple = tastyFromJSONFile.recipes.last {
      return Recipe(id: example.id, tastyRecipe: reciple, recipeType: .tastyRecipe)
    }
    return recipeExample
  }
}
