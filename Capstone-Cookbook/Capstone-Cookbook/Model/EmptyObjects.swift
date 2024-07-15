//
//  EmptyObjects.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import Foundation

struct EmptyObjects {
  func createEmptyIngredientComponent() -> Component {
    let ingredient = Ingredient(
      createdAt: Int(TimeInterval(Date().timeIntervalSince1970)),
      displayPlural: "",
      displaySingular: "",
      name: "",
      updatedAt: Int(TimeInterval(Date().timeIntervalSince1970)))

    let unit = createEmptyUnit()

      let measurement = Measurement(
        id: UUID().hashValue,
        quantity: "0",
        unit: unit)

    let component = Component(
      extraComment: "",
      rawText: "",
      position: 1,
      ingredient: ingredient,
      measurements: [measurement])

    return component
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
    Measurement(
      id: UUID().hashValue,
      quantity: "0",
      unit: createEmptyUnit())
  }
}
