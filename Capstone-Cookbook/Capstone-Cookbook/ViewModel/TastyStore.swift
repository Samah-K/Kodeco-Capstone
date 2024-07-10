//
//  TastyStore.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 10/07/2024.
//

import Foundation

class TastyStore {
  var tastyRecipes: [Recipe] = []
//  {
//    willSet {
//      print("tastyRecipes, will set")
//    }
//  }
  var tastyPage = TastyPage()

  //  func scaleRecipe(for recipeID: Int, numberOfPeople: Int) {
  //    if let index = tastyRecipes.firstIndex(where: { $0.id == recipeID }) {
  //      tastyRecipes[index].numberOfPeople = numberOfPeople
  //      if let nutrition = tastyRecipes[index].nutrition {
  //        if let calories = nutrition.calories {
  //          let cal = ((calories) * numberOfPeople) / tastyRecipes[index].numServing
  //          print("OLD: \(tastyRecipes[index].numServing) | \(calories)")
  //          print("NEW: \(numberOfPeople) | \(cal)")
  //        }
  //      }
  //    }
  //  }

//  func resetSearch() {
//    tastyRecipes = []
////    recipeCount = -1
//  }

//  func next(for searchQuery: String) {
//    if !TastyJSONSample().isPreview {
//      tastyPage.nextPage()
//      searchRecipes(for: searchQuery)
//    }
//  }

//  private func filterResults(tastyRecipes: [TastyRecipe]) -> [TastyRecipe] {
//    let filterTerms = [
//      "cocktails", "contains_alcohol", "rum", "whiskey", "tequila", "gin", "vodka", "wine",
//      "pork", "ham", "bacon"
//    ]
//    if filterTerms.isEmpty {
//      return tastyRecipes
//    }
//    let recipes: [TastyRecipe] = tastyRecipes.compactMap { recipe in
//      let recipeTags = recipe.tags.map { $0.name.lowercased() }
//      if !recipeTags.contains(where: { filterTerms.contains($0.lowercased()) }) {
//        if filterTerms.filter({ recipe.name.lowercased().contains($0.lowercased()) }).isEmpty {
//          return recipe
//        } else {
//          return nil
//        }
//      } else {
//        return nil
//      }
//    }
//    return recipes
//  }
}
