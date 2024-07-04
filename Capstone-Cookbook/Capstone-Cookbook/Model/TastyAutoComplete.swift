//
//  TastyAutoComplete.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

struct AutoComlete: Codable {
  let results: [AutoComleteResults]
}

struct AutoComleteResults: Codable {
  let display: String // apple pie
  let searchValue: String // apple pie
  let type: String // ingredient
  enum CodingKeys: String, CodingKey {
    case display
    case searchValue = "search_value"
    case type
  }
}
