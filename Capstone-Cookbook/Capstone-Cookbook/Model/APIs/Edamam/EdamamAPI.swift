//
//  EdamamAPI.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 07/07/2024.
//

import Foundation

struct EdamamAPI {
  func getAppID() -> String {
    return getAPIValueForKey(key: EdamamAPIKeys.appID.rawValue)
  }

  func getAppKey() -> String {
    return getAPIValueForKey(key: EdamamAPIKeys.key.rawValue)
  }

  private enum EdamamAPIKeys: String {
    case appID = "app_id"
    case key = "app_key"
  }

  private func getAPIValueForKey(key: String) -> String {
    guard let filePath = Bundle.main.path(forResource: "Edamam-Info", ofType: "plist")
    else {
      fatalError("Couldn't find file 'Edamam-Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: key) as? String
    else {
      fatalError("Couldn't find key \(key) in `Edamam-Info.plist`")
    }
    return value
  }
}
