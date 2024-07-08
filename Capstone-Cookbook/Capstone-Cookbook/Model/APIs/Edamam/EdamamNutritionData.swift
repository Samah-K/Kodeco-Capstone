//
//  EdamamNutritionData.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 07/07/2024.
//

import Foundation

struct EdamamNutritionData: Codable {
  let totalWeight: Double
  let totalNutrients: EdamamTotalNutrients
}

struct EdamamTotalNutrients: Codable {
  let energy: Nutrients?
  let protein: Nutrients?
  let fat: Nutrients?
  let sugar: Nutrients?
  let water: Nutrients?
  let carbohydrates: Nutrients?
  let fiber: Nutrients?

  enum CodingKeys: String, CodingKey {
    case energy = "ENERC_KCAL"
    case protein = "PROCNT"
    case fat = "FAT"
    case sugar = "SUGAR"
    case water = "WATER"
    case carbohydrates = "CHOCDF.net"
    case fiber = "FIBTG"
  }
}

struct Nutrients: Codable {
  let label: String
  let quantity: Double
  let unit: String
}
