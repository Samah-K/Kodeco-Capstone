//
//  AddIngredientProtocols.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import Foundation

protocol UpdateIngredientComponent {
  func saveComponent(componentID: String, ingredient: Ingredient, measurement: [Measurement], shouldAddComponent: AddOrEditEnum) // Add for add, don't add for edit
}

protocol CalculateAmountProtocol {
  func updateUI(to unitAmount: UnitAmounts, _ toSystem: UnitsSystem)
  func noResultWasFound()
}
