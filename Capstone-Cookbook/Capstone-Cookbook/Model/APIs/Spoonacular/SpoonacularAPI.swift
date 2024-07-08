//
//  SpoonacularAPI.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 07/07/2024.
//

import Foundation

struct SpoonacularAPI {
  func getAPIHeader() -> [String: String] {
    var apiHeader: [String: String] = [:]
    apiHeader[SpoonacularAPIKeys.host.rawValue] = getAPIValueForKey(key: SpoonacularAPIKeys.host.rawValue)
    apiHeader[SpoonacularAPIKeys.key.rawValue] = getAPIValueForKey(key: SpoonacularAPIKeys.key.rawValue)
    return apiHeader
  }

  private enum SpoonacularAPIKeys: String {
    case host = "rapidapi"
    case key = "x-rapidapi-key"
  }

  private func getAPIValueForKey(key: String) -> String {
    guard let filePath = Bundle.main.path(forResource: "Spoonacular-Info", ofType: "plist")
    else {
      fatalError("Couldn't find file 'Spoonacular-Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: key) as? String
    else {
      fatalError("Couldn't find key \(key) in `Spoonacular-Info.plist`")
    }
    return value
  }
}
