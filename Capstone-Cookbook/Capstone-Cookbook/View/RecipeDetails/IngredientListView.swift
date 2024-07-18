//
//  IngredientListView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 18/07/2024.
//

import SwiftUI

struct IngredientListView: View {
  @State var ingredientSection: [IngredientSections]
  var body: some View {
    List(ingredientSection) { section in
      Section {
        ForEach(section.components) { component in
          Text(HandleMeasurement().getIngredientDescription(
            ingredient: component.ingredient,
            measurements: component.measurements))
        }
      } header: {
        Text(section.name ?? "")
          .font(.title2)
      }
    }
  }
}

#Preview {
  struct Preview: View {
    private static let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    @State var recipe = Recipe(tastyRecipe: tastyRecipe, recipeType: .myRecipe)
    var body: some View {
      IngredientListView(ingredientSection: recipe.tastyRecipe.ingredientSections)
    }
  }
  return Preview()
}
