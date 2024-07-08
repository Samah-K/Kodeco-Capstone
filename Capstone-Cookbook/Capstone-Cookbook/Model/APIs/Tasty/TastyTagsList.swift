//
//  TastyTagsList.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

struct TagsList: Codable {
  let count: Int
  let results: [Tag]
}
struct Tag: Codable {
  let id: Int
  let type: String // difficulty
  let name: String // under_15_minutes
  let displayName: String // Under 15 Minutes
  enum CodingKeys: String, CodingKey {
    case displayName = "display_name"
    case id
    case type
    case name
  }
}

func removeTagsInList(tagsDictionary: inout [String: [String]], key: String, tagToRemove: String) {
  if var tagDictionary = tagsDictionary[key] {
    tagDictionary.removeAll { tag in
      tag.contains(tagToRemove)
    }
  }
}


// tagsDictionary.removeValue(forKey: "cocktails")
// removeTagsInList(tagsDictionary: &tagsDictionary, key: "drinks", tagToRemove: "Cocktails")
// removeTagsInList(tagsDictionary: &tagsDictionary, key: "meats", tagToRemove: "Pork")
// removeTagsInList(tagsDictionary: &tagsDictionary, key: "dinner", tagToRemove: "Pork")
// removeTagsInList(tagsDictionary: &tagsDictionary, key: "business_tags", tagToRemove: "pork")
