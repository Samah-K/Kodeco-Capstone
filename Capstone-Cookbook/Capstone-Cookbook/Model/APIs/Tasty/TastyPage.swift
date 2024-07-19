//
//  TastyPage.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 05/07/2024.
//

import Foundation

struct TastyPage {
  var from = 0
  let size = 20

  mutating func nextPage() {
    from += size
  }
}
