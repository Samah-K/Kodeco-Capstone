//
//  FileManager.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 11/07/2024.
//

import Foundation

public extension FileManager {
  static var documentDirectoryURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
