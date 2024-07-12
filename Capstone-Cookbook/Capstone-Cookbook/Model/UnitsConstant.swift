//
//  UnitsConstant.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 12/07/2024.
//

import Foundation

enum UnitsName: String, CaseIterable {
  case gram
  case kilogram
  case liter
  case milliliter
  case teaspoon
  case tablespoon
  case pound
  case ounce
  case cup
  case pint
  case box
  case clove
  case stick
  case slice
  case none

  func getUnitInfo() -> Unit? {
    if let unit = UnitsConstant().dictionary[self] {
      return unit
    }
    return nil
  }
  func getUnitSystem() -> UnitsSystem? {
    if let unit = UnitsConstant().dictionary[self] {
      if let unitSystem = UnitsSystem(rawValue: unit.system) {
        return unitSystem
      }
    }
    return nil
  }
}
enum UnitsSystem: String, CaseIterable {
  case metric
  case imperial
  case none
}

struct UnitsConstant {
  let dictionary =
  [
    UnitsName.gram: Unit(
      abbreviation: "g",
      displayPlural: "g",
      displaySingular: "g",
      name: UnitsName.gram.rawValue,
      system: UnitsSystem.metric.rawValue),
    UnitsName.kilogram: Unit(
      abbreviation: "kg",
      displayPlural: "kg",
      displaySingular: "kg",
      name: UnitsName.kilogram.rawValue,
      system: UnitsSystem.metric.rawValue),
    UnitsName.liter: Unit(
      abbreviation: "L",
      displayPlural: "L",
      displaySingular: "L",
      name: UnitsName.liter.rawValue,
      system: UnitsSystem.metric.rawValue),
    UnitsName.milliliter: Unit(
      abbreviation: "mL",
      displayPlural: "ml",
      displaySingular: "ml",
      name: UnitsName.milliliter.rawValue,
      system: UnitsSystem.metric.rawValue),
    UnitsName.teaspoon: Unit(
      abbreviation: "tsp",
      displayPlural: "teaspoons",
      displaySingular: "teaspoon",
      name: UnitsName.teaspoon.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.tablespoon: Unit(
      abbreviation: "tbsp",
      displayPlural: "teaspoons",
      displaySingular: "tablespoon",
      name: UnitsName.tablespoon.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.pound: Unit(
      abbreviation: "lb",
      displayPlural: "lb",
      displaySingular: "lb",
      name: UnitsName.pound.rawValue,
      system: UnitsSystem.imperial.rawValue),
    UnitsName.ounce: Unit(
      abbreviation: "oz",
      displayPlural: "oz",
      displaySingular: "oz",
      name: UnitsName.ounce.rawValue,
      system: UnitsSystem.imperial.rawValue),
    UnitsName.cup: Unit(
      abbreviation: "c",
      displayPlural: "cups",
      displaySingular: "cup",
      name: UnitsName.cup.rawValue,
      system: UnitsSystem.imperial.rawValue),
    UnitsName.pint: Unit(
      abbreviation: "pt",
      displayPlural: "pt",
      displaySingular: "pt",
      name: UnitsName.kilogram.rawValue,
      system: UnitsSystem.imperial.rawValue),
    UnitsName.box: Unit(
      abbreviation: "box",
      displayPlural: "boxes",
      displaySingular: "box",
      name: UnitsName.box.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.clove: Unit(
      abbreviation: "clove",
      displayPlural: "cloves",
      displaySingular: "clove",
      name: UnitsName.clove.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.stick: Unit(
      abbreviation: "stick",
      displayPlural: "sticks",
      displaySingular: "stick",
      name: UnitsName.stick.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.slice: Unit(
      abbreviation: "slice",
      displayPlural: "slices",
      displaySingular: "slice",
      name: UnitsName.slice.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.none: Unit(
      abbreviation: "",
      displayPlural: "",
      displaySingular: "",
      name: UnitsName.none.rawValue,
      system: UnitsSystem.none.rawValue)
  ]

  let unitsInUnitSystems = [
    UnitsSystem.metric: [UnitsName.gram, UnitsName.kilogram, UnitsName.liter, UnitsName.milliliter],
    UnitsSystem.imperial: [UnitsName.pound, UnitsName.ounce, UnitsName.cup],
    UnitsSystem.none: [
      UnitsName.teaspoon, UnitsName.tablespoon,
      UnitsName.box, UnitsName.clove, UnitsName.stick, UnitsName.slice,
      UnitsName.none
    ]
  ]
}
// Used in Tasty
// clove | clove | clove | cloves | none
// milliliter | mL | mL | mL | metric
// pint | pt | pt | pt | imperial
// cup | c | cup | cups | imperial
// box | box | box | boxes | none
// gram | g | g | g | metric
// teaspoon | tsp | teaspoon | teaspoons | imperial
// kilogram | kg | kg | kg | metric
// liter | L | L | L | metric
// tablespoon | tbsp | tablespoon | tablespoons | imperial
// pound | lb | lb | lb | imperial
// stick | stick | stick | sticks | none
// ounce | oz | oz | oz | imperial
// slice | slice | slice | slices | none
//  |  |  |  | none
