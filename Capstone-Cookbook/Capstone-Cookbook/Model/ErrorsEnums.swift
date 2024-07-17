//
//  ErrorsEnums.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation


enum NetworkError: LocalizedError {
  case invalidSearchQuery
  case invalidURL
  case invalidResponse
  case invalidData
  case apiPlanExceeded
  case invalidURLForImage

  var errorDescription: String? {
    switch self {
    case .invalidSearchQuery:
      TextsConstants().emptySearchAlertTitle
    case .invalidURL:
      "Invalid URL"
    case .invalidResponse:
      "Invalid Response"
    case .invalidData:
      "Invalid Data"
    case .apiPlanExceeded:
      "Oh no!\nPlease call the developer"
    case .invalidURLForImage:
      "Something went wrong"
    }
  }
}

enum FileErrors: Error {
  case previewJSONFileNotExists // RecipesSample.json for preview
  case cannotSaveImage // AddEditRecipe pick an image
}
