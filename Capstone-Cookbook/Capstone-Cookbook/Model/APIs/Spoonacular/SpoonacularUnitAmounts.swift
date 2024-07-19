//
//  ConvertAmounts.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 07/07/2024.
//

import Foundation

// Spoonacular API
struct UnitAmounts: Decodable {
  let sourceUnit: String
  let sourceAmount: Double
  let targetUnit: String
  let targetAmount: Double
  var ingredient: String?
}
