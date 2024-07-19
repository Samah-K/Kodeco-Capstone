//
//  HandleMeasurement.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 14/07/2024.
//

import Foundation

struct HandleMeasurement {
  // [½, ⅓, ⅔, ¼, ¾, ⅕, ⅖, ⅗, ⅘, ⅙, ⅚, ⅐, ⅛, ⅜, ⅝,⅞, ⅑, ⅒]
  let vulgarFractionDic: [String: Double] = [
    "½": 1.0 / 2.0,
    "⅓": 1.0 / 3.0,
    "⅔": 2.0 / 3.0,
    "¼": 1.0 / 4.0,
    "¾": 3.0 / 4.0,
    "⅕": 1.0 / 5.0,
    "⅖": 2.0 / 5.0,
    "⅗": 3.0 / 5.0,
    "⅘": 4.0 / 5.0,
    "⅙": 1.0 / 6.0,
    "⅚": 5.0 / 6.0,
    "⅐": 1.0 / 7.0,
    "⅛": 1.0 / 8.0,
    "⅜": 3.0 / 8.0,
    "⅝": 5.0 / 8.0,
    "⅞": 7.0 / 8.0,
    "⅑": 1.0 / 9.0,
    "⅒": 1.0 / 10.0
  ]

  func convertQuantity(quantity: String) -> Double {
    if let quantity = Double(quantity) {
      return quantity
    } else {
      return removeVulgarFunction(from: quantity)
    }
  }

  func calculateTotalTime(prepTime: Int, cookTime: Int) -> String {
    let totalTime = prepTime + cookTime
    let hours = totalTime / 60
    let minutes = totalTime % 60
    var minutesText = ""
    var hoursText = ""

    if hours == 1 {
      hoursText = "\(hours) hour"
    } else if hours == 0 {
      hoursText = ""
    } else {
      hoursText = "\(hours) hours"
    }
    if minutes == 1 {
      minutesText = "\(minutes) minute"
    } else if minutes == 0 {
      minutesText = ""
    } else {
      minutesText = "\(minutes) minutes"
    }
    return "\(hoursText) \(minutesText)"
  }

  // Some quantity has vulgar fraction [½], and it can't be converted to Double, so we need to replace that with the actual value [0.5 instead of ½]
  private func removeVulgarFunction(from  quantity: String) -> Double {
    let fractionsKeys = Array(vulgarFractionDic.keys)
    var quantityValue = quantity // will remove this part [½] from it
    var fractionValue = 0.0 // 0.5 instead of ½

    quantity.forEach { char in
      if fractionsKeys.contains(where: { $0 == "\(char)" }) {
        fractionValue = vulgarFractionDic["\(char)"] ?? 0.0
        quantityValue.replace("\(char)", with: "")
        //        print("\(quantity) -> \(quantityValue)")
      }
    }
    quantityValue = quantityValue.trimmingCharacters(in: .whitespaces)
    if let quantityInt = Double(quantityValue) {
      return quantityInt + fractionValue
    } else if quantityValue.isEmpty {
      return fractionValue
    }
    return 0.0
  }

  func getIngredientDescription(ingredient: Ingredient, measurements: [Measurement]) -> String {
    let ingredientName = ingredient.name
    var ingredientMeasurement = ""
    if measurements.count == 1 {
      // .none
      let measurement = measurements[0]
      let quantity = convertQuantity(quantity: measurement.quantity)
      if measurement.unit.system == "none" && measurement.unit.abbreviation.isEmpty {
        if quantity == 0 {
          let name = ingredient.displaySingular ?? ingredientName
          return "\(name)" // salt
        } else if quantity > 0 && quantity <= 1.0 {
          let name = ingredient.displaySingular ?? ingredientName
          return "\(quantity) \(name)" // 1 egg
        } else {
          let name = ingredient.displayPlural ?? ingredientName
          return "\(quantity) \(name)" // 3 Apples
        }
      } else {
        return "\(getMeasurementDescription(measurement)) \(ingredientName)"
      }
    } else {
      // .Metric or .imperial
      var metricMeasurement = ""
      var imperialMeasurement = ""
      measurements.forEach { measurement in
        ingredientMeasurement = getMeasurementDescription(measurement)
        if measurement.unit.system == UnitsSystem.imperial.rawValue {
          imperialMeasurement = "\(ingredientMeasurement) \(ingredientName)"
        } else if measurement.unit.system == UnitsSystem.metric.rawValue {
          metricMeasurement = "\(ingredientMeasurement) \(ingredientName)"
        }
      }
      return "\(metricMeasurement)\n\(imperialMeasurement)"
    }
  }

  private func getMeasurementDescription(_ measurement: Measurement) -> String {
    let quantity = convertQuantity(quantity: measurement.quantity)
    var measurementName: String = ""
    if quantity <= 1.0 {
      measurementName = measurement.unit.displaySingular
    } else {
      measurementName = measurement.unit.displayPlural
    }
    return "\(quantity) \(measurementName) of"
  }
}
