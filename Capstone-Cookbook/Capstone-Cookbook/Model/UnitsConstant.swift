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
  case fluidOunce
  case cup
  case pint
  case gallon
  case box
  case clove
  case stick
  case slice
  case strip
  case drizzle
  case sprinkle
  case bunch
  case handful
  case pinch
  case can
  case jar
  case package
  case sprig
  case piece
  case shot
  case bag
  case teabag
  case container
  case inchPiece
  case scoop
  case smallClove
  case dash
  case stalk
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

enum UnitSystemGroup: String {
  case metricOrImperial = "Metric | Imperial"
  case none
}

struct MeasurementAndUnit {
  var quantity: Double
  var unit: UnitsName
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
      name: UnitsName.pint.rawValue,
      system: UnitsSystem.imperial.rawValue),
    UnitsName.fluidOunce: Unit(
      abbreviation: "fl oz",
      displayPlural: "fl oz",
      displaySingular: "fl oz",
      name: UnitsName.fluidOunce.rawValue,
      system: UnitsSystem.imperial.rawValue),
    UnitsName.gallon: Unit(
      abbreviation: "gal",
      displayPlural: "gal",
      displaySingular: "gal",
      name: UnitsName.gallon.rawValue,
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
    UnitsName.drizzle: Unit(
      abbreviation: "drizzle",
      displayPlural: "drizzle",
      displaySingular: "drizzle",
      name: UnitsName.drizzle.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.bunch: Unit(
      abbreviation: "bunch",
      displayPlural: "bunches",
      displaySingular: "bunch",
      name: UnitsName.bunch.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.handful: Unit(
      abbreviation: "handful",
      displayPlural: "handfuls",
      displaySingular: "handful",
      name: UnitsName.handful.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.strip: Unit(
      abbreviation: "strip",
      displayPlural: "strips",
      displaySingular: "strip",
      name: UnitsName.strip.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.pinch: Unit(
      abbreviation: "pinch",
      displayPlural: "pinchs",
      displaySingular: "pinch",
      name: UnitsName.pinch.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.can: Unit(
      abbreviation: "can",
      displayPlural: "cans",
      displaySingular: "can",
      name: UnitsName.can.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.sprinkle: Unit(
      abbreviation: "sprinkle",
      displayPlural: "sprinkles",
      displaySingular: "sprinkle",
      name: UnitsName.sprinkle.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.jar: Unit(
      abbreviation: "jar",
      displayPlural: "jars",
      displaySingular: "jar",
      name: UnitsName.jar.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.stalk: Unit(
      abbreviation: "stalk",
      displayPlural: "stalks",
      displaySingular: "stalk",
      name: UnitsName.stalk.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.package: Unit(
      abbreviation: "package",
      displayPlural: "packages",
      displaySingular: "package",
      name: UnitsName.package.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.sprig: Unit(
      abbreviation: "sprig",
      displayPlural: "sprigs",
      displaySingular: "sprig",
      name: UnitsName.sprig.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.piece: Unit(
      abbreviation: "piece",
      displayPlural: "pieces",
      displaySingular: "piece",
      name: UnitsName.piece.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.bag: Unit(
      abbreviation: "bag",
      displayPlural: "bags",
      displaySingular: "bag",
      name: UnitsName.bag.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.teabag: Unit(
      abbreviation: "tea bag",
      displayPlural: "tea bags",
      displaySingular: "tea bag",
      name: UnitsName.teabag.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.shot: Unit(
      abbreviation: "shot",
      displayPlural: "shots",
      displaySingular: "shot",
      name: UnitsName.shot.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.container: Unit(
      abbreviation: "container",
      displayPlural: "containers",
      displaySingular: "container",
      name: UnitsName.container.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.inchPiece: Unit(
      abbreviation: "inch piece",
      displayPlural: "inch pieces",
      displaySingular: "inch piece",
      name: UnitsName.inchPiece.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.scoop: Unit(
      abbreviation: "scoop",
      displayPlural: "scoops",
      displaySingular: "scoop",
      name: UnitsName.scoop.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.smallClove: Unit(
      abbreviation: "small clove",
      displayPlural: "small cloves",
      displaySingular: "small clove",
      name: UnitsName.smallClove.rawValue,
      system: UnitsSystem.none.rawValue),
    UnitsName.dash: Unit(
      abbreviation: "dash",
      displayPlural: "dashes",
      displaySingular: "dash",
      name: UnitsName.dash.rawValue,
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
    UnitsSystem.imperial: [
      UnitsName.pound, UnitsName.ounce, UnitsName.cup, UnitsName.pint,
      UnitsName.fluidOunce, UnitsName.gallon
    ],
    UnitsSystem.none: [
      UnitsName.teaspoon, UnitsName.tablespoon,
      UnitsName.box, UnitsName.clove, UnitsName.stick, UnitsName.slice,
      UnitsName.drizzle, UnitsName.sprinkle, UnitsName.handful, UnitsName.pinch,
      UnitsName.bunch, UnitsName.can, UnitsName.jar, UnitsName.package,
      UnitsName.sprig, UnitsName.piece, UnitsName.shot, UnitsName.bag,
      UnitsName.teabag, UnitsName.container, UnitsName.inchPiece, UnitsName.scoop,
      UnitsName.smallClove, UnitsName.dash, UnitsName.stalk,
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
// handful | handful | handful | handfuls | none
// strip | strip | strip | strips | none
// pinch | pinch | pinch | pinches | none
// can | can | can | cans | none
// sprinkle | sprinkle | sprinkle | sprinkles | none
// pinch | pinch | pinch | pinches | none
// jar | jar | jar | jars | none
// stalk | stalk | stalk | stalks | none
// package | package | package | packages | none
// sprig | sprig | sprig | sprigs | none
// piece | piece | piece | pieces | none
// tea bag | tea bag | tea bag | tea bags | none
// bag | bag | bag | bags | none
// shot | shot | shot | shots | none
// container | container | container | containers | none
// inch piece | inch piece | inch piece | inch pieces | none
// fluid ounce | fl oz | fl oz | fl oz | imperial
// scoop | scoop | scoop | scoops | none
// small clove | small clove | small clove | small cloves | none
// dash | dash | dash | dashes | none
// gallon | gal | gal | gal | imperial
// drizzle | drizzle | drizzle | drizzle | none
// inch piece | inch piece | inch piece | inch pieces | none
// bunch | bunch | bunch | bunches | none
