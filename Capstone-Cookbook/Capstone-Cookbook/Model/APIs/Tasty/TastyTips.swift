//
//  TastyTips.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

struct Tips: Codable {
  let count: Int
  let results: [TipsResult]
}

struct TipsResult: Codable {
  let authoName: String?
  let authorUsername: String
  let authorAvatarUrl: String
  let tipBody: String // the comment
  let updatedAt: Int
  let upvotesTotal: Int
  let tipPhoto: TipPhoto?

  enum CodingKeys: String, CodingKey {
    case tipBody         = "tip_body"
    case authorAvatarUrl = "author_avatar_url"
    case authoName       = "author_name"
    case authorUsername  = "author_username"
    case updatedAt       = "updated_at"
    case upvotesTotal    = "upvotes_total"
    case tipPhoto = "tip_photo"
  }
  // check both username and authername, usually one is nil and the other is not
  // upvotesTotal is for the tip
  // createdAt is always nil [I removed it form the struct]
}

struct TipPhoto: Codable {
  let height: Int
  let width: Int
  let url: String
}
