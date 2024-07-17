//
//  EmptyObjects.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import Foundation

struct EmptyObjects {
  func createEmptyIngredientComponent() -> Component {
    let ingredient = createEmptyIngredient()
    let measurement = createEmptyMeasurement()
    return Component(
      extraComment: "",
      rawText: "",
      position: 1,
      ingredient: ingredient,
      measurements: [measurement])
  }
  func createEmptyIngredient() -> Ingredient {
    return Ingredient(
      createdAt: Int(TimeInterval(Date().timeIntervalSince1970)),
      displayPlural: "",
      displaySingular: "",
      name: "",
      updatedAt: Int(TimeInterval(Date().timeIntervalSince1970)))
  }
  func createEmptyUnit() -> Unit {
    return Unit(
      abbreviation: "",
      displayPlural: "",
      displaySingular: "",
      name: "",
      system: UnitsSystem.none.rawValue)
  }
  func createEmptyMeasurement() -> Measurement {
    return Measurement(
      id: UUID().hashValue,
      quantity: "0",
      unit: createEmptyUnit())
  }
}
