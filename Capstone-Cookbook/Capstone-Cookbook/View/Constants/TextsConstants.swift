//
//  Texts.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 14/07/2024.
//

import Foundation

enum TextsConstants {
  static let measurementHowTo =
  """
  Measurement units can be:\n
  • Metric or Imperial:
  You can enter one value and use the calculation button to calculate the other.
  🍴Make sure to provide both units🍴\n
  • NONE, this can be a teaspoon, tablespoon, slice, etc., or _none_ for things like eggs.
  """

  static let leavingIngredientConfirmation = "Are you sure you want to leave editing the ingredient?"
  static let leavingInstructionConfirmation = "Are you sure you want to leave editing the instruction?"
  static let leavingRecipeConfirmation = "Are you sure you want to leave editing the Recipe?"
  static let pleaseEnterIngredientNameAlertTitle = "Empty Ingredeint Name"
  static let pleaseEnterIngredientNameAlertMessage = "An ingredient should at least has a name."
  static let pleaseEnterRecipeNameAlertTitle = "Empty Recipe Name"
  static let pleaseEnterRecipeNameAlertMessage = "Please enter the recipe name."
  static let failedToConvetAmountAlertTitle = "Calculation Failed"
  static let failedToConvetAmountAlertMessage = "Try changing the ingredient name."
  static let removeSectionConfirmationAlertTitle = "Are you sure you want to remove the section?"
  static let removeSectionConfirmationAlertMessage = "You will lose all the added ingredient"
  static let removeRecipeConfirmationAlertTitle = "Are you sure you want to remove the Recipe?"
  static let emptySearchAlertTitle = "Please enter something to search"
  static let InstructionsButton = "Instructions"
  static let IngredientButton = "Check Ingredient"
  static let emptyCookBook =
  """
  Oh no!
  Looks like your cookbook is empty 😮
  ✨ Let’s start our cooking journey ✨
  """
  static let emptyCookBookAddNewRecipes = "Add a new recipe"
  static let emptyCookBookExplore = "Explore and get inspired"
}
