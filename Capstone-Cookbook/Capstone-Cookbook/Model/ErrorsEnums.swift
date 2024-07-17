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
}

enum FileErrors: Error {
  case previewJSONFileNotExists // RecipesSample.json for preview
  case cannotSaveImage // AddEditRecipe pick an image
}
