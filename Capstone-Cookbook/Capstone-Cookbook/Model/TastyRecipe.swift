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
  let recipes: [Recipe]
  enum CodingKeys: String, CodingKey {
    case count
    case recipes = "results"
  }
}

struct Recipe: Codable, Identifiable {
  let id: Int
  let name: String
  let description: String
  let prepTimeMinutes: Int?
  let cookTimeMinutes: Int?
  let totalTimeMinutes: Int?
  let instructions: [Instructions]
  let sections: [Section]
  let keywords: String?
  // family dinner, jonah peretti, secret ingredient pasta, tasty, tasty_contains_alcohol, tomato and anchovy pasta recipe, umami pasta
  let numServing: Int
  let thumbnailURL: String // https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/109214.jpg
  let beautyURL: String? // https://img.buzzfeed.com/video-api-prod/assets/cf1fdbad99ef4b278ca7b8c61504b6c2/Beauty2_Thumb.jpg
  let originalVideoURL: String? // https://s3.amazonaws.com/video-api-prod/assets/723faf4d7887464b82e81d2604797f83/BFV30681_ApplePieCheescake_FB1080SQ.mp4
  let videoURL: String? // https://vid.tasty.co/output/57946/low_1508803850.m3u8
  let nutrition: Nutrition?
  let language: String // eng
  // tags
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case description
    case prepTimeMinutes  = "prep_time_minutes"
    case cookTimeMinutes  = "cook_time_minutes"
    case totalTimeMinutes = "total_time_minutes"
    case instructions
    case sections
    case keywords
    case numServing = "num_servings"
    case originalVideoURL = "original_video_url"
    case videoURL     = "video_url"
    case thumbnailURL = "thumbnail_url"
    case beautyURL = "beauty_url"
    case nutrition = "nutrition"
    case language  = "language"
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
  let calories: Int?
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
  let id = UUID()
  //   let start_time: Int
  //   let end_time: Int
  //   let temperature: Int
  enum CodingKeys: String, CodingKey {
    case displayText = "display_text"
    case appliance   = "appliance"
  }
}

struct Section: Codable, Identifiable {
  let components: [Component]
  let id = UUID()
  enum CodingKeys: CodingKey {
    case components
  }
}

struct Ingredient: Codable {
  let createdAt: Int
  let displayPlural: String
  let displaySingular: String
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

struct Component: Codable, Identifiable {
  var id = UUID()
  let extraComment: String
  let rawText: String
  var ingredient: Ingredient
  var measurements: [Measurement]
  enum CodingKeys: String, CodingKey {
    case extraComment = "extra_comment"
    case rawText      = "raw_text"
    case ingredient, measurements
  }
}

struct TastyRecipeModel {
  func getExample() -> Recipe {
    //    let instructionsExample = [
    //      Instructions(displayText: "In a medium-sized bowl, add the flour and salt. Mix with fork until combined.", appliance: nil),
    //      Instructions(displayText: "Add in cubed butter and break up into flour with a fork. Mixture will still have lumps about the size of small peas.", appliance: nil),
    //      Instructions(displayText: "Gradually add the ice water and continue to mix until the dough starts to come together. You may not need all of the water, but if the dough is too dry then add more. The dough should not be very tacky or sticky.", appliance: nil),
    //      Instructions(displayText: "Work the dough together with your hands and turn out onto a surface. Work into a ball and cover with cling wrap. Refrigerate.", appliance: nil),
    //      Instructions(displayText: "Peel the apples, then core and slice.", appliance: nil),
    //      Instructions(displayText: "In a bowl, add the sliced apples, sugar, flour, salt, cinnamon, nutmeg, and juice from the lemon.", appliance: nil),
    //      Instructions(displayText: "Mix until combined and all apples are coated. Refrigerate.", appliance: nil),
    //      Instructions(displayText: "Preheat the oven to 375°F (200°C).", appliance: "oven"),
    //      Instructions(displayText: "On a floured surface, cut the pie dough in half and roll out both halves until round and about ⅛-inch (3 mm) thick.", appliance: nil),
    //      Instructions(displayText: "Roll the dough around the rolling pin and unroll onto a pie dish making sure the dough reaches all edges. Trim extra if necessary.", appliance: nil),
    //      Instructions(displayText: "Pour in apple filling mixture and pat down.", appliance: nil),
    //      Instructions(displayText: "Roll the other half of the dough on top.", appliance: nil),
    //      Instructions(displayText: "Trim the extra dough from the edges and pinch the edges to create a crimp. Make sure edges are sealed together.", appliance: nil),
    //      Instructions(displayText: "Brush the pie with the beaten egg and sprinkle with the sugar.", appliance: nil),
    //      Instructions(displayText: "Cut four slits in the top of the pie to create a vent.", appliance: nil),
    //      Instructions(displayText: "Bake pie for 50-60 minutes or until the crust is golden brown and no greyish or undercooked pastry remains.", appliance: nil),
    //      Instructions(displayText: "Allow to cool completely before slicing.", appliance: nil),
    //      Instructions(displayText: "Top with ice cream and serve.", appliance: nil),
    //      Instructions(displayText: "Enjoy!", appliance: nil)
    //    ]
    let example = Recipe(
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
      sections: [],
      keywords: "apple, apple pie, bake, buzzfeed, comfort food, dessert, easy, "
      + "from scratch, fruit, homemade, pie, tasty, tasty_vegetarian",
      numServing: 8,
      thumbnailURL: "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/2b422cd19f6c488fbe649da9739b5542/fb.jpg",
      beautyURL: nil,
      originalVideoURL: "https://s3.amazonaws.com/video-api-prod/assets/3593865599de4bf8a15d528c2b18cc69/fb.mp4",
      videoURL: "https://vid.tasty.co/output/29645/low_1492635519.m3u8",
      nutrition: nil,
      language: "eng")
    let recipe = TastyJSON().getRecipeFromJSONFile() ?? example
    return recipe
  }
  //  let sectionsExample = [
  //    Section(components: [
  //
  //      Component(extraComment: "",
  //                rawText: "2½ cups flour",
  //                ingredient: Ingredient(createdAt: 1493314654, displayPlural: "flours", displaySingular: "flour", id: 25, name: "flour", updatedAt: 1509035288),
  //                measurements: [
  //                  Measurement(id: 773220, quantity: "2 ½", unit: Unit(abbreviation: "c", displayPlural: "cups", displaySingular: <#T##String#>, name: <#T##String#>, system: <#T##String#>))
  //                ])
  //
  //    ])
  //  ]
  //

  //
}
