//
//  TastyAPI.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

struct TastyAPI {
  func getAPIHeader() -> [String: String] {
    var apiHeader: [String: String] = [:]
    apiHeader[TastyAPIKeys.host.rawValue] = getAPIValueForKey(key: TastyAPIKeys.host.rawValue)
    apiHeader[TastyAPIKeys.key.rawValue]  = getAPIValueForKey(key: TastyAPIKeys.key.rawValue)
    return apiHeader
  }

  private enum TastyAPIKeys: String {
    case host = "x-rapidapi-host"
    case key  = "x-rapidapi-key"
  }

  private func getAPIValueForKey(key: String) -> String {
    guard let filePath = Bundle.main.path(forResource: "Tasty-Info", ofType: "plist")
    else {
      fatalError("Couldn't find file `Tasty-Info.plist`.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: key) as? String
    else {
      fatalError("Couldn't find key `\(key)` in `Tasty-Info.plist`.")
    }
    return value
  }
}
