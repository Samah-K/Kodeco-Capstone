//
//  Texts.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 14/07/2024.
//

import Foundation

enum TextsConstants {
  static let measurementHowTo = "Measurement units can be:\n• Metric or Imperial." +
  "You can enter both values for the two systems, or you can enter one value, and the app will calculate the other" +
  "for you. You only need to provide the unit in the other system to which you want the app to convert." +
  "\n• NONE, this can be teaspoon, tablespoon, clove, stick, slice, box, or `none` for things like eggs"

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
  static let emptySearchAlertTitle = "Please enter something to search"
}
