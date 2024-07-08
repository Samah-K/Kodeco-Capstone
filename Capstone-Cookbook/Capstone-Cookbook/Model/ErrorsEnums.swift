//
//  ErrorsEnums.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation


enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case invalidData
  case apiPlanExceeded
  case invalidURLForImage
}
