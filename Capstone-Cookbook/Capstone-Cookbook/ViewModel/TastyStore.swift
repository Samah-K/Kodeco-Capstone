//
//  TastyStore.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

class TastyStore: ObservableObject {
  @Published var tastyRecipes: [Recipe] = []
  @Published var errorText: String?
  var recipeCount = -1
  let networkService = TastyNetworkService()
  func printError(error: String) {
    Task {
      await MainActor.run {
        print(error)
      }
    }
  }
  func searchRecipes(for searchQuery: String) {
    Task {
      do {
        let tasty = try await networkService.getListOfRecipes(searchQuery: searchQuery)
        await MainActor.run {
          print(tasty.recipes)
          print("tasty.count \(tasty.count)")
          self.tastyRecipes = tasty.recipes
          self.recipeCount = tasty.count
        }
      } catch NetworkError.invalidURL {
        errorText = "Invalid URL"
        printError(error: errorText ?? "Something went wrong")
      } catch NetworkError.invalidResponse {
        errorText = "Invalid URL"
        printError(error: errorText ?? "Something went wrong")
      } catch NetworkError.invalidData {
        errorText = "Invalid Data"
        printError(error: errorText ?? "something went wrong")
      } catch {
        errorText = error.localizedDescription
        printError(error: errorText ?? "something went wrong")
      }
    }
  }
  func resetSearch() {
    tastyRecipes = []
    recipeCount = -1
  }
}
