//
//  Attempt.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 07/07/2024.
//

import Foundation

struct Attempt: Identifiable {
  let id = UUID()
  let attemptNumber: Int
  var name: String
  var date: Date
  var score: Double // [score/10]
  var comments: String
  var image: String? // or URL 
}
