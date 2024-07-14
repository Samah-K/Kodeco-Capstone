//
//  HandleMeasurement.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 14/07/2024.
//

import Foundation

struct HandleMeasurement {
  func convertQuantity(quantity: String) -> Double {
    if let quantity = Double(quantity) {
      return quantity
    } else {
      return removeVulgarFunction(from: quantity)
    }
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
        print("\(quantity) -> \(quantityValue)")
      }
    }
    if let quantityInt = Double(quantityValue) { //
      return quantityInt + fractionValue
    } else if quantityValue.isEmpty {
      return fractionValue
    }
    return 0.0
  }

  func getIngredientDescription(ingredient: Ingredient, measurement: Measurement) -> String {
    let ingredientName = ingredient.name
    var ingredientMeasurement = ""
    let quantity = convertQuantity(quantity: measurement.quantity)
    if measurement.unit.system == "none" && measurement.unit.abbreviation.isEmpty {
      if quantity <= 1.0 {
        let name = ingredient.displaySingular ?? ingredientName
        return "\(measurement.quantity) \(name)" // 1 egg
      } else {
        let name = ingredient.displayPlural ?? ingredientName
        return "\(measurement.quantity) \(name)" // 3 Apples
      }
    } else {
      var measurementName: String = ""
      if quantity <= 1.0 {
        measurementName = measurement.unit.displaySingular
      } else {
        measurementName = measurement.unit.displayPlural
      }
      //      if measurements.count <= 1 {
      ////        let measurement = measurements[0]
      //        let quantity = measurement.quantity
      //        let name = measurement.unit.name
      //        ingredientMeasurement = (quantity == "0") ? "\(name)" : "\(quantity) \(name) of"
      //      } else {
      // metric or imperial
      //        let measurement = measurements[0]
      //      let quantity = measurement.quantity
      //      let name = measurement.unit.displayPlural // measurement.unit.name
      ingredientMeasurement = "\(quantity) \(measurementName) of"
      return "\(ingredientMeasurement) \(ingredientName)"
    }
  }
}
